class SessionsController < ApplicationController
  def create
    if params[:provider] == 'wechat'
      user_from_auth(WechatAuthentication.create_with_code(params[:code]))
    elsif params[:provider] == 'github'
      req = request.env['omniauth.auth']
      req[:avatar_url] = request.env['omniauth.auth']['extra']['raw_info']['avatar_url']
      user_from_auth(req)
    else
      redirect_to root_path
    end
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
    redirect_to books_path
  end
end
