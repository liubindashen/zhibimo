class Build < ActiveRecord::Base
  validates_presence_of :name, :email, :message, :at, :hash
  belongs_to :book

  include AASM

  aasm do
    state :idle, initial: true
    state :building
    state :complete
    state :warning

    event :do do
      transitions :from => [:idle, :warning, :complete], :to => :building
    end

    event :oops do
      transitions :from => :building, :to => :warning
    end

    event :done do
      transitions :from => :building, :to => :complete
    end
  end

  def read_url
    "/commits/#{book.namespace}/#{commit}"
  end

  def short_commit
    commit.first 7
  end
end
