class SessionsController < ApplicationController
  def create
    if params[:provider] == 'wechat'
      req = WechatAuthentication.create_with_code(params[:code])
      req[:avatar_url] = req[:info][:avatar]
      user_from_auth(req)
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

  def auth
    author = Author.find_by_username(request.env['HTTP_X_ORIGINAL_AUTHOR'])

    book = author && author.books
      .find_by_slug(request.env['HTTP_X_ORIGINAL_BOOK'])

    if book && book.free?
      render nothing: true, status: 200
    elsif book && book.purchase? && book.check_purchaser(current_user)
      render nothing: true, status: 200
    else
      render nothing: true, status: 403
    end
  end

  private
  def user_from_auth(auth)
    user = User.from_auth(auth)
    session[:user_id] = user.id
    redirect_to pop_redirect_back_url || root_path
  end
end
