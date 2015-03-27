class Book < ActiveRecord::Base
  belongs_to :user

  def repo
    path = "/tmp/repos/#{user.id}/#{self.id}"
    git = Rugged::Repository.new(path) rescue Rugged::Repository.init_at(path)
    git.workdir
  rescue => e
    puts e
  end

  after_create do
    destroy unless repo
  end

  after_destroy do
    FileUtils.rm_rf(repo)
  end
end
