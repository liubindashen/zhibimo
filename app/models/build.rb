class Build < ActiveRecord::Base
  validates_presence_of :name, :email, :message, :at, :hash
  belongs_to :book

  def short_commit
    commit.first 7
  end
end
