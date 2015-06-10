class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true, format: {with: /\A[a-z0-9][a-z0-9_\-]{1,128}\Z/i}
  validates_uniqueness_of :email, allow_nil: true

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  has_many :books, dependent: :destroy

  def add_auth(auth)
    authentications.create(:provider => auth[:provider],
                           :uid => auth[:uid])
  end

  def avatar_url(default)
    attr_url = read_attribute(:avatar_url)
    attr_url.blank? ? default : attr_url
  end

  class << self
    def from_auth(auth)
      locate_auth(auth) || create_auth(auth)
    end

    def locate_auth(auth)
      Authentication.find_by_provider_and_uid(auth[:provider], auth[:uid]).try(:user)
    end

    def create_auth(auth)
      create!(
        :email => auth[:info][:email],
        :username => auth[:info][:name],
        :authentications_attributes => [
          Authentication.new(:provider => auth[:provider],
                             :uid => auth[:uid]
                            ).attributes
      ])
    end
  end

  after_create do
    UserRegisterJob.perform_later self

    unless ENV['DISABLE_GITLIB']
      pwd = SecureRandom.hex
      oh = Gitlab.create_user("#{id}@zhibimo.com", pwd, username: id.to_s, projects_limit: 100)
      raise 'Failed to create git usr' unless oh.id.present?
      update_columns(gitlab_id: oh.id, gitlab_password: pwd)
    end
  end

  after_destroy do
    http = HTTParty.delete(
      "#{ENV['GITLAB_ENDPOINT']}/users/#{gitlab_id}",
      headers: {
        'Content-Type' => 'application/json',
        'PRIVATE-TOKEN' => Gitlab.private_token
      }
    )
    p http
  end
end
