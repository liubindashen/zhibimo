class Author < ActiveRecord::Base
  validates :pen_name, presence: true, uniqueness: true
  validates :intro, presence: true

  belongs_to :user

  has_many :books, dependent: :destroy

  delegate :avatar, :username, :to => :user
end
