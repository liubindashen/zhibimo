class Book < ActiveRecord::Base
  belongs_to :user

  def entries
    repo.index.entries.map { |e| e[:path] }
  end

  def entry_read(path)
    IO.readlines(workdir + path).join("\n")
  end

  def entry_update(path, content = "", message = nil)
    _repo = repo
    message ||= "[SYSTEM] AUTO SAVE " + Time.now.utc.to_s

    oid = _repo.write(content, :blob)
    index = _repo.index
    index.read_tree(_repo.head.target.tree)
    index.add(:path => path, :oid => oid, :mode => 0100644)

    options = {
      tree: index.write_tree(_repo),
      author: {
        email: "#{user.username}@zhibimo.com",
        name: user.username,
        time: Time.now
      },
      committer: {
        email: "#{user.username}@zhibimo.com",
        name: user.username,
        time: Time.now
      },
      message: message,
      parents: _repo.empty? ? [] : [ _repo.head.target ].compact,
      update_ref: 'HEAD'
    }
    Rugged::Commit.create(_repo, options)
  end

  def entry_destroy(path)
  end

  def repo
    path = "/tmp/repos/#{user.id}/#{self.id}"
    Rugged::Repository.new(path) rescue Rugged::Repository.init_at(path)
  end

  def workdir
    repo.workdir rescue nil
  end

  after_create do
    destroy unless repo
  end

  after_destroy do
    FileUtils.rm_rf(workdir) if workdir
  end
end
