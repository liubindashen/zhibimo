json.wxConfig do
  json.appId ENV['WX_APP_ID']
end

if @current_user
  json.currentUser do
    json.extract! @current_user, :id, :username
  end
end
