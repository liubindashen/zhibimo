class SessionsController < ApplicationController
  def create
    user = User.from_auth(request.env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to '/dashboard/index'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: t('.notice')
  end

  def fail
    redirect_to root_url, error: t('.error')
  end
end

