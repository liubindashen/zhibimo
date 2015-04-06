class Book < ActiveRecord::Base
  has_many :entries, dependent: :destroy
  belongs_to :user

  def self.from_hook(pl)
    user = User.find_by!(gitlab_id: pl['user_id'].to_i)
    book = user.books.find_by!(gitlab_id: pl['project_id'].to_i)
    return if book.building?
    book.update_columns(building: true)

    FileUtils.mkdir_p("#{Dir.home}/book-repos/#{user.id}")
    book_repo = "#{Dir.home}/book-repos/#{user.id}/#{book.id}"
    FileUtils.rm_rf(book_repo)
    system("git clone #{book.git_origin} #{book_repo}")

    FileUtils.mkdir_p("#{Dir.home}/book-builds/#{user.id}/#{book.id}")
    book_new = "#{Dir.home}/book-builds/#{user.id}/#{book.id}/#{pl['after']}"
    system("gitbook build #{book_repo} #{book_new}")

    FileUtils.mkdir_p("#{Dir.home}/books/#{user.username}")
    book_current = "#{Dir.home}/books/#{user.username}/#{book.slug}"
    book_old = File.readlink(book_current) rescue nil

    system("ln -snf #{book_new} #{book_current}")
    FileUtils.rm_rf(book_old) if book_old.present?

    book.update_attributes(building: false)
  rescue => e
    book.update_attributes(building: false)
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

    oh = Gitlab.add_project_hook(gitlab_id, "http://zhibimo.com/books/#{id}/hook")
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
