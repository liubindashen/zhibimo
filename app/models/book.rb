class Book < ActiveRecord::Base

  has_many :entries, dependent: :destroy
  validates :slug, presence: true, uniqueness: {scope: :author_id}, format: {with: /\A[a-z0-9][a-z0-9_\-]{1,512}\Z/i}

  validates :gitlab_id, presence: true, uniqueness: true, on: :update

  belongs_to :author

  mount_uploader :cover, CoverUploader

  before_validation :set_default_slug
  before_validation :set_default_user_id

  scope :explored, -> { where(explored: true) }

  def gitlab
    Gitlab.project gitlab_id
  end

  def cover_url(default = nil)
    File.exists?("#{Dir.home}/books/#{author.username}/#{slug}/cover.jpg") ?
      "http://zhibimo.com/read/#{author.username}/#{slug}/cover.jpg" : default
  end

  def build(force: false)
    return if building?
    update_columns(building: true)

    user = author.user

    FileUtils.mkdir_p("#{Dir.home}/book-repos/#{user.id}")
    book_repo = "#{Dir.home}/book-repos/#{user.id}/#{id}"
    FileUtils.rm_rf(book_repo)
    system("git clone #{git_origin_with_build} #{book_repo}")
    commit = `cd #{book_repo} && git log --pretty=format:%H -1`.strip
    commit_time = `cd #{book_repo} && git log --pretty=format:%ci -1`.to_time

    update_columns(building: false) and return if (commit == version and !force)

    update_columns(readme: File.read("#{book_repo}/README.md"), summary: File.read("#{book_repo}/SUMMARY.md"))

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

  def self.from_hook(pl)
    user = User.find_by!(gitlab_id: pl['user_id'].to_i)
    user.books.find_by!(gitlab_id: pl['project_id'].to_i)
  end

  def entry_create(path, content = "", message = nil)
    entry = entries.create(path: path)
    return nil unless entry.valid?
    #entry.repo_update(content, message || "[SYSTEM] ADD " + path)
    entry
  end

  def git_origin_with_build
    "git@#{ENV['GITLAB_REPO_HOST']}:#{author.user.id}/#{self.id}.git"
  end

  def git_origin
    "http://git.zhibimo.com/#{author.user.id}/#{self.id}.git"
  end

  after_create do
    unless ENV['DISABLE_GITLIB']
      project = Gitlab.create_project slug, path: slug, user_id: author.gitlab_id
      update_attributes!(gitlab_id: project.id)
      Gitlab.add_project_hook(project.id, Rails.application.routes.url_helpers.hook_book_builds_url(id, host: 'zhibimo.com'))
    end
  end

  after_destroy do
    unless ENV['DISABLE_GITLIB']
      Gitlab.delete_project gitlab_id
    end
  end

  private

  def set_default_slug
    if (!self.slug or self.slug.empty?) and self.title
      self.slug = Pinyin.t(self.title, splitter: '-')
    end
    self.slug.downcase!
  end

  def set_default_user_id
    self.user_id = 0
  end

end
