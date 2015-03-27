class Book < ActiveRecord::Base
  has_many :entries, dependent: :destroy
  belongs_to :user

  def entry_create(path)
    entry = entries.create(path: path)
    return nil unless entry.valid?
    entry.repo_update
    entry
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
