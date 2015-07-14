class Author < ActiveRecord::Base
  validates :pen_name, presence: true, uniqueness: true
  validates :intro, presence: true

  belongs_to :user

  has_many :books, dependent: :destroy

  delegate :username, :gitlab_id, :gitlab_password, :to => :user

  mount_uploader :avatar, AvatarUploader
end
