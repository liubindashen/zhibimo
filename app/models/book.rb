class Book < ActiveRecord::Base
  has_many :entries, dependent: :destroy
  belongs_to :user

  def entry_create(path, content = "", message = nil)
    entry = entries.create(path: path)
    return nil unless entry.valid?
    entry.repo_update(content, message || "[SYSTEM] ADD " + path)
    entry
  end

  def git_origin
    "http://#{user.gitlab_id}:#{user.gitlab_password}@git.zhibimo.com/#{user.gitlab_id}/#{self.gitlab_id}.git"
  end

  def workdir
    # whenever we want to do some operations, should clone a unique copy
    "/tmp/repos/#{user.gitlab_id}/#{self.gitlab_id}/#{SecureRandom.hex}"
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
