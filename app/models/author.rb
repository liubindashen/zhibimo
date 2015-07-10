class Author < ActiveRecord::Base
  validates :pen_name, presence: true, uniqueness: true
  validates :intro, presence: true

  belongs_to :user

  has_many :books, dependent: :destroy, primary_key: :user_id, foreign_key: :user_id

  def slogan
    '弃我去者昨日之日亦可留 乱我心者今日之日莫忧愁'
  end

  def avatar_url
    '/avatar.jpg'
  end
end
