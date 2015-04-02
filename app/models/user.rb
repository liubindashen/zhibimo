class User < ActiveRecord::Base
  validates :username, :presence => true
  validates :email, :presence => true, :uniqueness => true

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  has_many :books, dependent: :destroy

  def add_auth(auth)
    authentications.create(:provider => auth[:provider],
                           :uid => auth[:uid])
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
    pwd = SecureRandom.hex
    oh = Gitlab.create_user("#{id}@zhibimo.com", pwd, username: id.to_s, projects_limit: 100)
    raise 'Failed to create git usr' unless oh.id.present?
    update_columns(gitlab_id: oh.id, gitlab_password: pwd)
  end

  after_destroy do
    http = HTTParty.delete(
      "http://git.zhibimo.com/api/v3/users/#{gitlab_id}",
      headers: {
        'Content-Type' => 'application/json',
        'PRIVATE-TOKEN' => Gitlab.private_token
      }
    )
    p http
  end
end
