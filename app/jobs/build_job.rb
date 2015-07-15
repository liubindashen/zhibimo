class BuildJob < ActiveJob::Base
  queue_as :building

  def perform(id)
    build = Build.find id
    book = build.book
    author = book.author

    FileUtils.mkdir_p("#{Dir.home}/book-repos/#{user.id}")
    book_repo = "#{Dir.home}/book-repos/#{user.id}/#{id}"
    FileUtils.rm_rf(book_repo)
    system("git clone #{git_origin_with_build} #{book_repo}")
    commit = `cd #{book_repo} && git log --pretty=format:%H -1`.strip
    commit_time = `cd #{book_repo} && git log --pretty=format:%ci -1`.to_time

    update_columns(building: false) and return if (commit == version and !force)

    update_columns(readme: File.read("#{book_repo}/README.md"), summary: File.read("#{book_repo}/SUMMARY.md"))
  end

  def make_html
  end

  def make_pdf
  end

  def make_mobi
  end

  def make_epub
  end

    # HTML begin
    File.open("#{Dir.home}/.book.json", 'w') do |f|
      f.puts JSON.dump({
        language: 'zh-cn',
        plugins: %w(tongji),
        pluginsConfig: {
          tongji: {
            token: ENV['TONGJI_TOKEN']
          }
        }
      })
    end

    # settings
    system("cat #{Dir.home}/.book.json > #{book_repo}/book.json")

    FileUtils.mkdir_p("#{Dir.home}/book-builds/#{user.id}/#{id}")
    html_new = "#{Dir.home}/book-builds/#{user.id}/#{id}/#{commit}"
    system("gitbook build #{book_repo} #{html_new}")

    FileUtils.mkdir_p("#{Dir.home}/books/#{user.username}")
    html_current = "#{Dir.home}/books/#{user.username}/#{slug}"
    html_old = File.readlink(html_current) rescue nil

    if File.exists?(html_new)
      system("ln -snf #{html_new} #{html_current}")
      FileUtils.rm_rf(html_old) if html_old.present? && html_old != html_new
    end
    # HTML end

    # EPUB begin
    FileUtils.mkdir_p("#{Dir.home}/book-builds/#{user.id}/#{id}")
    epub_new = "#{Dir.home}/book-builds/#{user.id}/#{id}/#{commit}.epub"
    system("gitbook epub #{book_repo} #{epub_new}")

    FileUtils.mkdir_p("#{Dir.home}/books/#{user.username}")
    epub_current = "#{Dir.home}/books/#{user.username}/#{slug}.epub"
    epub_old = File.readlink(epub_current) rescue nil

    if File.exists?(epub_new)
      system("ln -snf #{epub_new} #{epub_current}")
      FileUtils.rm_rf(epub_old) if epub_old.present? && epub_old != epub_new
    end
    # EPUB end

    # MOBI begin
    FileUtils.mkdir_p("#{Dir.home}/book-builds/#{user.id}/#{id}")
    mobi_new = "#{Dir.home}/book-builds/#{user.id}/#{id}/#{commit}.mobi"
    system("gitbook mobi #{book_repo} #{mobi_new}")

    FileUtils.mkdir_p("#{Dir.home}/books/#{user.username}")
    mobi_current = "#{Dir.home}/books/#{user.username}/#{slug}.mobi"
    mobi_old = File.readlink(mobi_current) rescue nil

    if File.exists?(mobi_new)
      system("ln -snf #{mobi_new} #{mobi_current}")
      FileUtils.rm_rf(mobi_old) if mobi_old.present? && mobi_old != mobi_new
    end
    # MOBI end

    # PDF begin
    FileUtils.mkdir_p("#{Dir.home}/book-builds/#{user.id}/#{id}")
    pdf_new = "#{Dir.home}/book-builds/#{user.id}/#{id}/#{commit}.pdf"
    system("xvfb-run gitbook pdf #{book_repo} #{pdf_new}")

    FileUtils.mkdir_p("#{Dir.home}/books/#{user.username}")
    pdf_current = "#{Dir.home}/books/#{user.username}/#{slug}.pdf"
    pdf_old = File.readlink(pdf_current) rescue nil

    if File.exists?(pdf_new)
      system("ln -snf #{pdf_new} #{pdf_current}")
      FileUtils.rm_rf(pdf_old) if pdf_old.present? && pdf_old != pdf_new
    end
    # PDF end

    update_attributes(building: false, version: commit, version_time: commit_time)
  rescue => e
    update_attributes(building: false)
    raise e
  end

  rescue

  end
end
