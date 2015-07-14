class Author < ActiveRecord::Base
  validates :pen_name, presence: true, uniqueness: true
  validates :intro, presence: true

  validates :gitlab_id, presence: true, uniqueness: true, on: :update
  validates :gitlab_username, presence: true, uniqueness: true, on: :update

  belongs_to :user

  has_many :books, dependent: :destroy

  delegate :username, :to => :user

  mount_uploader :avatar, AvatarUploader

  def gitlab
    Gitlab.user gitlab_id
  end

  after_create do
    UserRegisterJob.perform_later self.username

    unless ENV['DISABLE_GITLIB']
      pwd = SecureRandom.hex
      gitlab_user = Gitlab.create_user("#{username}@zhibimo.com", pwd, name: pen_name, username: username)
      update_attributes!(gitlab_id: gitlab_user.id, gitlab_username: username, gitlab_password: pwd)
    end
  end
end
