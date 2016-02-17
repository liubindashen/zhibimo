require 'open3'
class BuildJob < ActiveJob::Base
  queue_as :building

  def perform(id, force: false)
    build = Build.find(id)
    return unless build.may_do?
    build.do!

    build.with_lock do
      begin
        process(build)
        build.done!
      rescue
        build.oops!
      end
    end
  end

  # repos path example:
  #   books/author/book/scm
  # books path example:
  #   books/author/book/repelase/commit/
  #   books/author/book/repelase/commit/book.pdf
  #   books/author/book/repelase/commit/book.epub
  #   books/author/book/repelase/commit/book.mobi
  # books link example:
  #   books/author/book/current/
  #
  def process(build)

    book = build.book
    book.makedir

    FileUtils.cd book.path do
      FileUtils.rm_rf commit_path = "#{book.commits_path}/#{build.commit}"
      FileUtils.rm_rf release_path = "#{book.release_path}/#{build.commit}"
      FileUtils.mkdir_p commit_path
      FileUtils.mkdir_p release_path

      current_path = "current"


      # begin
      book.fetch_remote_repo
      # rescue => err
        # puts err
      # end


      # prework for book source
      FileUtils.cd commit_path do
        # clone commit with build for repo
        system("git clone #{book.git_path} . --recursive --branch master")
        system('git rev-parse HEAD > .git_revision')
        system('git rev-parse HEAD > git-version.html')

        FileUtils.rm_rf '.git'

        # check SUMMARY.md and README.md
        FileUtils.touch %w(SUMMARY.md README.md)

        # check book.json config file
        File.open('book.json', 'w') do |conf|
          conf.puts JSON.dump({
            language: 'zh-cn',
            plugins: %w(tongji),
            pluginsConfig: { tongji: { token: ENV['TONGJI_TOKEN'] } }
          })
        end

        new_readme = File.read('README.md')
        new_summary = File.read('SUMMARY.md')
        book.update_attributes readme: new_readme, summary: new_summary
        Rails.logger.info 'update readme and summary'
      end

      system("sed -i 's/\\s/ /g' #{commit_path}/*")

      # build html to books/author/book/release/commit/
      #cmd =
      system("gitbook build #{commit_path} #{release_path}/ --log=debug --debug")
      # Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      #   build.update(build_log: stdout.read)
      # end
      if book.free?
        # build pdf to books/author/book/release/commit/book.mobi
        mobi_output = "#{release_path}/#{book.slug}.mobi"
        system("gitbook mobi #{commit_path} #{mobi_output}")

        # build epub to books/author/book/release/commit/book.epub
        epub_output = "#{release_path}/#{book.slug}.epub"
        system("gitbook epub #{commit_path} #{epub_output}")

        # build pdf to books/author/book/release/commit/book.pdf
        pdf_output = "#{release_path}/#{book.slug}.pdf"
        system("xvfb-run gitbook pdf #{commit_path} #{pdf_output}")
      end

      system("rm -rf #{current_path} && ln -sf #{release_path} #{current_path}")
    end
  end
end
