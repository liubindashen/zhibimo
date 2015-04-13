class WechatAuthentication < ActiveRecord::Base
  validates_presence_of :openid
  validates_uniqueness_of :openid

  belongs_to :user

  def self.create_with_code(code)
    conn = Faraday.new(:url => 'https://api.weixin.qq.com') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    opts = {
      code: code,
      appid: ENV['WX_APP_ID'],
      secret: ENV['WX_APP_SECRET'],
      grant_type: 'authorization_code'
    }

    result = conn.get '/sns/oauth2/access_token', opts
    token = JSON.parse(result.body).symbolize_keys!

    wechat_authentication = find_or_create_by!(openid: token[:openid])
    wechat_authentication.update_attributes \
      unionid: token[:unionid], 
      refresh_token: token[:refresh_token],
      access_token: token[:access_token]

    opts = { 
      access_token: wechat_authentication.access_token, 
      openid: wechat_authentication.openid
    }

    userinfo = conn.get '/sns/userinfo', opts
    userinfo = JSON.parse(userinfo.body).symbolize_keys!

    username = Pinyin.t(userinfo[:nickname], splitter: '-')
    info = {name: username, sex: userinfo[:sex], gravatar: userinfo[:headimgurl]}
    { provider: 'wechat-web', uid: userinfo[:openid], info: info }
  end
end
