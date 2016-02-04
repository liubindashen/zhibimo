class Team < ActiveRecord::Base
  belongs_to :book
  belongs_to :author

  after_create :add_user_to_project

  def add_user_to_project
    Gitlab.configure do |config|
      config.endpoint       = 'http://git.zhibimo.com/api/v3'
      config.private_token  = self.book.author.gitlab_private_token
    end
    Gitlab.add_team_member(self.book.author.gitlab_id, self.author.gitlab_id, 40)
  end

end
