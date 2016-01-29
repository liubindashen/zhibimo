class Author < ActiveRecord::Base
  validates :pen_name, presence: true, uniqueness: true
  validates :intro, presence: true

  validates :gitlab_id, presence: true, uniqueness: true, on: :update
  validates :gitlab_username, presence: true, uniqueness: true, on: :update

  belongs_to :user

  has_many :books, dependent: :destroy
  has_many :orders, dependent: :destroy

  has_many :withdraws, dependent: :destroy

  delegate :username, :email, :to => :user

  scope :find_by_username, -> (username) {
    joins(:user).find_by('users.username' => username)
  }

  mount_uploader :avatar, AvatarUploader

  def gitlab
    Gitlab.user gitlab_id
  end

  def balance
    if self.withdraws != nil
      total = self.orders.where(aasm_state: "complete").sum(:fee) * 0.9 - self.withdraws.sum(:amount)
    else
      total = self.orders.where(aasm_state: "complete").sum(:fee) * 0.9
    end
  end

  def fee
    if self.withdraws != nil
      total = self.orders.where(aasm_state: "complete").sum(:fee) * 0.1 - self.withdraws.sum(:fee)
    else
      total = self.orders.where(aasm_state: "complete").sum(:fee) * 0.1
    end
  end

  after_create do
    UserRegisterJob.perform_later self.username

    unless ENV['DISABLE_GITLIB']
      pwd = SecureRandom.hex
      gitlab_user = Gitlab.create_user("#{username}@zhibimo.com", pwd, name: pen_name, username: username)
      update_attributes!(gitlab_id: gitlab_user.id, gitlab_username: username, gitlab_password: pwd)
    end
  end

  after_destroy do
    unless ENV['DISABLE_GITLIB']
      Gitlab.delete_user gitlab_id
    end
  end
end
