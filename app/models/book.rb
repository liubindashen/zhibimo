class Book < ActiveRecord::Base
  has_many :entries, dependent: :destroy
  validates :slug, presence: true, format: {with: /\A[a-z0-9][a-z0-9_\-]{1,512}\Z/i}
  belongs_to :user

  def cover_url(default)
    File.exists?("#{Dir.home}/books/#{user.username}/#{slug}/cover.jpg") ?
      "http://zhibimo.com/read/#{user.username}/#{slug}/cover.jpg" : default
  end

  def self.from_hook(pl)
    user = User.find_by!(gitlab_id: pl['user_id'].to_i)
    book = user.books.find_by!(gitlab_id: pl['project_id'].to_i)
    return if book.building?
    book.update_columns(building: true)

    FileUtils.mkdir_p("#{Dir.home}/book-repos/#{user.id}")
    book_repo = "#{Dir.home}/book-repos/#{user.id}/#{book.id}"
    FileUtils.rm_rf(book_repo)
    system("git clone #{book.git_origin} #{book_repo}")

    book.update_columns(readme: File.read("#{book_repo}/README.md"), summary: File.read("#{book_repo}/SUMMARY.md"))

    # HTML begin
    FileUtils.mkdir_p("#{Dir.home}/book-builds/#{user.id}/#{book.id}")
    html_new = "#{Dir.home}/book-builds/#{user.id}/#{book.id}/#{pl['after']}"
    system("gitbook build #{book_repo} #{html_new}")

    FileUtils.mkdir_p("#{Dir.home}/books/#{user.username}")
    html_current = "#{Dir.home}/books/#{user.username}/#{book.slug}"
    html_old = File.readlink(html_current) rescue nil

    system("ln -snf #{html_new} #{html_current}")
    FileUtils.rm_rf(html_old) if html_old.present?
    # HTML end

    # EPUB begin
    FileUtils.mkdir_p("#{Dir.home}/book-builds/#{user.id}/#{book.id}")
    epub_new = "#{Dir.home}/book-builds/#{user.id}/#{book.id}/#{pl['after']}.epub"
    system("gitbook epub #{book_repo} #{epub_new}")

    FileUtils.mkdir_p("#{Dir.home}/books/#{user.username}")
    epub_current = "#{Dir.home}/books/#{user.username}/#{book.slug}.epub"
    epub_old = File.readlink(epub_current) rescue nil

    system("ln -snf #{epub_new} #{epub_current}")
    FileUtils.rm_rf(epub_old) if epub_old.present?
    # EPUB end

    # PDF begin
    FileUtils.mkdir_p("#{Dir.home}/book-builds/#{user.id}/#{book.id}")
    pdf_new = "#{Dir.home}/book-builds/#{user.id}/#{book.id}/#{pl['after']}.pdf"
    system("xvfb-run gitbook pdf #{book_repo} #{pdf_new}")

    FileUtils.mkdir_p("#{Dir.home}/books/#{user.username}")
    pdf_current = "#{Dir.home}/books/#{user.username}/#{book.slug}.pdf"
    pdf_old = File.readlink(pdf_current) rescue nil

    system("ln -snf #{pdf_new} #{pdf_current}")
    FileUtils.rm_rf(pdf_old) if pdf_old.present?
    # PDF end

    commit = pl['after']
    commit_time = pl['commits'].find { |c| c['id'] == commit }['timestamp'].to_time
    book.update_attributes(building: false, version: commit, version_time: commit_time)
  rescue => e
    book.update_attributes(building: false) if book
    raise e
  end

  def entry_create(path, content = "", message = nil)
    entry = entries.create(path: path)
    return nil unless entry.valid?
    entry.repo_update(content, message || "[SYSTEM] ADD " + path)
    entry
  end

  def git_origin
    "http://#{user.id}:#{user.gitlab_password}@git.zhibimo.com/#{user.id}/#{self.id}.git"
  end

  after_create do
    http = HTTParty.post(
      "http://git.zhibimo.com/api/v3/projects/user/#{user.gitlab_id}",
      headers: {
        'Content-Type' => 'application/json',
        'PRIVATE-TOKEN' => Gitlab.private_token
      },
      body: {
        name: id.to_s,
        issues_enabled: false,
        merge_requests_enabled: false,
        wiki_enabled: false,
        snippets_enabled: false
      }.to_json
    )
    body = JSON.parse(http.body)
    raise 'Failed to to create git repository: ' + http.body unless http.code == 201 && body['id'].present?
    update_column(:gitlab_id, body['id'])

    oh = Gitlab.add_project_hook(gitlab_id, "http://zhibimo.com/api/v1/books/#{id}/hook")
    raise 'Failed to create git hook' unless oh.id.present?
    # entry_create("README.md", "This is the README.md", "[SYSTEM] ADD README.md")
    # entry_create("SUMMARY.md", "", "[SYSTEM] ADD SUMMARY.md")
  end

  after_destroy do
    FileUtils.rm_rf("/tmp/repos/#{user.gitlab_id}/#{self.gitlab_id}/")
    http = HTTParty.delete(
      "http://git.zhibimo.com/api/v3/projects/#{gitlab_id}",
      headers: {
        'Content-Type' => 'application/json',
        'PRIVATE-TOKEN' => Gitlab.private_token
      }
    )
    p http
  end
end
