class Author < ActiveRecord::Base
  validates :pen_name, presence: true, uniqueness: true
  validates :intro, presence: true

  belongs_to :user

  has_many :books, dependent: :destroy

  delegate :username, :to => :user

  mount_uploader :avatar, AvatarUploader

  def gitlab_info
    Gitlab.user gitlab_id
  end

  after_create do
    UserRegisterJob.perform_later self.username

    unless ENV['DISABLE_GITLIB']
      pwd = SecureRandom.hex
      gitlab_user = Gitlab.create_user("#{username}@zhibimo.com", pwd, name: pen_name, username: username)
      raise 'Failed to create Gitlab user.' unless gitlab_user.id.present?
      update_columns(gitlab_id: gitlab_user.id, gitlab_username: username, gitlab_password: pwd)
    end
  end
end
