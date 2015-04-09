class Entry < ActiveRecord::Base
  belongs_to :book

  def to_json
    { content: repo_content, path: path, id: id }
  end

  def repo_content
    File.read(book.workdir + path)
  end

  def repo_update(content = "", message = nil)
    author = "#{book.author.username} <#{book.author.username}@zhibimo.com>"
    message ||= "[SYSTEM] AUTO UPDATE " + Time.now.utc.to_s
    File.open(book.workdir + path, 'w') { |f| f.puts content }
    system("git -C #{book.workdir} add #{path}")
    system("git -C #{book.workdir} commit --author=#{Shellwords.escape(author)} --message=#{Shellwords.escape(message)} #{path}")
    BookWorker.perform_async(book.id.to_s) unless message.start_with?('[SYSTEM]')
  end

  before_save do
    self.path = self.path + '.md' unless self.path.end_with?(".md")
  end

  # TODO: `LocalJumpError: unexpected return` when destroy Book
  #before_destroy do
    #return false if self.path == 'SUMMARY.md' || self.path == 'README.md'
    #author = "#{book.author.username} <#{book.author.username}@zhibimo.com>"
    #message = "[SYSTEM] ENTRY DELETE " + path
    #system("git -C #{book.workdir} rm -rf #{path}")
    #system("git -C #{book.workdir} commit --author=#{Shellwords.escape(author)} --message=#{Shellwords.escape(message)}")
  #end
end
