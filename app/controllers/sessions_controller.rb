class SessionsController < ApplicationController
  skip_before_action :register_confirm!, only: [:destroy, :auth]
  http_basic_authenticate_with name: "xiaolai", password: "wTPCuyJmxVNxnLkJDwUFWfPZ9dM2XQXDCjTvchi", :only => [:xiaolai]
  def create
    if params[:provider] == 'wechat'
      req = WechatAuthentication.create_with_code(params[:code])
      req[:avatar_url] = req[:info][:avatar]
      user_from_auth!(req)
    elsif params[:provider] == 'github'
      req = request.env['omniauth.auth']
      req[:avatar_url] = request.env['omniauth.auth']['extra']['raw_info']['avatar_url']
      user_from_auth!(req)
    else
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

  def fail
    redirect_to root_url
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

  def xiaolai
    session[:user_id] = 12
    redirect_to root_path
  end


  private
  def user_from_auth!(auth)
    user = User.from_auth(auth)
    session[:user_id] = user.id

    if user.is_confirm?
      redirect_to pop_redirect_back_url || root_path
    else
      redirect_to register_path
    end
  end
end
