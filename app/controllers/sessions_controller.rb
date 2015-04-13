class SessionsController < ApplicationController
  def create
    user_from_auth(request.env['omniauth.auth'])
  end

  def create_with_wechat
    user_from_auth(WechatAuthentication.create_with_code(params[:code]))
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: t('.notice')
  end

  def fail
    redirect_to root_url, error: t('.error')
  end

  private
  def user_from_auth(auth)
    user = User.from_auth(auth)
    session[:user_id] = user.id
    redirect_to '/dashboard/books/'
  end
end

