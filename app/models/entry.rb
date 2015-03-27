class Entry < ActiveRecord::Base
  belongs_to :book

  def to_json
    { content: repo_content, path: path, id: id }
  end

  def repo_content
    IO.readlines(book.workdir + path).join("\n")
  end

  def repo_update(content = "", message = nil)
    author = "#{book.user.username} <#{book.user.username}@zhibimo.com>"
    message ||= "[SYSTEM] AUTO UPDATE " + Time.now.utc.to_s
    File.open(book.workdir + path, 'w') { |f| f.puts content }
    system("git -C #{book.workdir} add #{path}")
    system("git -C #{book.workdir} commit --author=#{Shellwords.escape(author)} --message=#{Shellwords.escape(message)} #{path}")
  end

  before_destroy do
    author = "#{book.user.username} <#{book.user.username}@zhibimo.com>"
    message = "[SYSTEM] ENTRY DELETE " + path
    system("git -C #{book.workdir} rm -rf #{path}")
    system("git -C #{book.workdir} commit --author=#{Shellwords.escape(author)} --message=#{Shellwords.escape(message)}")
  end
end
