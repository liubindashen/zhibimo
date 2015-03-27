class User < ActiveRecord::Base
  validates :username, :presence => true
  validates :email, :presence => true, :uniqueness => true

  has_many :authentications
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
end
