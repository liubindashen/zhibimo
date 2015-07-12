Gitlab.configure do |config|
  config.endpoint       = ENV['GITLAB_ENDPOINT']
  config.private_token  = ENV['GITLAB_PRIVATE_TOKEN']
end
