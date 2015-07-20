class BuildJob < ActiveJob::Base
  queue_as :building

  def perform(id, force: false)
    build = Build.find(id)

    # update build state to start

    # repos path example: 
    #   books/author/book/scm
    # books path example: 
    #   books/author/book/repelase/commit/
    #   books/author/book/repelase/commit/book.pdf
    #   books/author/book/repelase/commit/book.epub
    #   books/author/book/repelase/commit/book.mobi
    # books link example:
    #   books/author/book/current/

    FileUtils.mkdir_p book_path = "#{Dir.home}/books/#{build.book.namespace}"

    FileUtils.cd book_path do
      FileUtils.mkdir_p git_path = "scm"
      FileUtils.mkdir_p commits_path = "commits"
      FileUtils.mkdir_p release_path = "release"

      FileUtils.rm_rf commit_path = "#{commits_path}/#{build.commit}"
      FileUtils.rm_rf release_path = "#{release_path}/#{build.commit}"
      FileUtils.mkdir_p commit_path 
      FileUtils.mkdir_p release_path

      current_path = "current"

      # sync book git repo
      if File.exists?("#{git_path}/objects")
        FileUtils.cd git_path do
          system("git fetch #{build.book.git_origin_with_build} master:master --force")
        end
      else
        system("git clone #{build.book.git_origin_with_build} #{git_path} --bare")
      end

      # prework for book source
      FileUtils.cd commit_path do
        # clone commit with build for repo
        system("git clone ../../#{git_path} . --recursive --branch master")
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
      end

      # build html to books/author/book/release/commit/
      system("gitbook build #{commit_path} #{release_path}")

      # build pdf to books/author/book/release/commit/book.mobi
      mobi_output = "#{release_path}/#{build.book.slug}.mobi"
      system("gitbook mobi #{commit_path} #{mobi_output}")

      # build epub to books/author/book/release/commit/book.epub
      epub_output = "#{release_path}/#{build.book.slug}.epub"
      system("gitbook epub #{commit_path} #{epub_output}")

      # build pdf to books/author/book/release/commit/book.pdf
      pdf_output = "#{release_path}/#{build.book.slug}.pdf"
      system("xvfb-run gitbook pdf #{commit_path} #{pdf_output}")

      system("rm -f #{current_path} && ln -sf #{release_path} #{current_path}")
    end
  end
end