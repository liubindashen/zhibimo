class UserRegisterJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    # TODO: send welcome to wechat
    # send notify to slack
    Slack.send("USER REGISTER #{user.username} / SUM COUNT: #{User.count}")
  end
end
