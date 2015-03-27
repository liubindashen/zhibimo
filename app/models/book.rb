class Book < ActiveRecord::Base
  belongs_to :user

  def entries
    repo.index.entries.map { |e| e[:path] }
  end

  def entry_read(path)
    return if path.blank?
    IO.readlines(workdir + path).join("\n")
  end

  def entry_update(path, content = "", message = nil)
    return if path.blank?
    author = "#{user.username} <#{user.username}@zhibimo.com>"
    message ||= "[SYSTEM] AUTO UPDATE " + Time.now.utc.to_s
    File.open(workdir + path, 'w') { |f| f.puts content }
    system("git -C #{workdir} add #{path}")
    system("git -C #{workdir} commit --author=#{Shellwords.escape(author)} --message=#{Shellwords.escape(message)} #{path}")
  end

  def entry_destroy(path)
    return if path.blank?
    author = "#{user.username} <#{user.username}@zhibimo.com>"
    message = "[SYSTEM] ENTRY DELETE " + path
    system("git -C #{workdir} rm -rf #{path}")
    system("git -C #{workdir} commit --author=#{Shellwords.escape(author)} --message=#{Shellwords.escape(message)}")
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
