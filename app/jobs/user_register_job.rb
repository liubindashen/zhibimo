class UserRegisterJob < ActiveJob::Base
  queue_as :default

  def perform(username)
    # TODO: send welcome to wechat
    # send notify to slack
    Slack.send("USER REGISTER #{username} / SUM COUNT: #{User.count}")
  end
end
