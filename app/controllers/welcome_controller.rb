class WelcomeController < ApplicationController
  before_action :auth_visitor!, only: :new

  layout 'landing'

  def index
  end

  def new
    gon.wxConfig = {appId: ENV['WECHAT_APP_ID']}
  end
end
