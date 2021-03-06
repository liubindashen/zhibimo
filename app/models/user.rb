class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true, format: {with: /\A[a-z0-9][a-z0-9_\-]{1,128}\Z/i}
  validates_uniqueness_of :email, allow_nil: true

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  has_one :author
  has_many :books, foreign_key: :user_id
  has_many :orders, foreign_key: :purchaser_id

  mount_uploader :avatar, AvatarUploader

  def add_auth(auth)
    authentications.create(:provider => auth[:provider],
                           :uid => auth[:uid])
  end

  def confirm(params)
    self.is_confirm = true
    self.username = params[:username]
    self.email = params[:email] if params[:email] and !params[:email].blank?
    self.save
  end

  def display_name
    return author.pen_name if author
    username
  end

  class << self
    def from_auth(auth)
      user = locate_auth(auth) || create_auth(auth)

      if user.avatar.blank? or (user.created_at < Time.at(1443009699))
        user.remote_avatar_url = auth[:avatar_url]
        user.save!

        if user.author
          user.author.remote_avatar_url = auth[:avatar_url]
          user.author.save!
        end
      end

      user
    end

    def locate_auth(auth)
      Authentication.find_by_provider_and_uid(auth[:provider], auth[:uid]).try(:user)
    end

    def create_auth(auth)
      username = "#{SecureRandom.hex(3)}-#{auth[:info][:name].downcase || 'username'}"

      create!(
        :email => "#{username}@zhibimo.com",
        :username => username,
        :authentications_attributes => [
          Authentication.new(:provider => auth[:provider],
                             :uid => auth[:uid]
                            ).attributes
      ])
    end
  end
end
