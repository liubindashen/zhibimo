class Build < ActiveRecord::Base
  validates_presence_of :name, :email, :message, :at, :hash
  belongs_to :book

  include AASM

  aasm do
    state :idle, initial: true
    state :building
    state :publishing

    event :build do
      transitions :from => :idle, :to => :building
    end

    event :done do
      transitions :from => :building, :to => :idle
    end

    event :publish do
      transitions :from => :idle, :to => :publishing
    end

    event :revocation do
      transitions :from => :publishing, :to => :idle
    end
  end

  def read_url
    "/read/#{book.namespace}/commits/#{commit}"
  end

  def short_commit
    commit.first 7
  end
end
