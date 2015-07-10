class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :current_author, \
    :push_redirect_back_url, :pop_redirect_back_url

  private

  def current_user
    @current_user ||= ::User.find_by_id(session[:user_id])
  end

  def current_author
    @current_author ||= (current_user && current_user.author)
  end

  def auth_user!
    unless current_user
      push_redirect_back_url
      redirect_to signin_path 
    end
  end

  def auth_author!
    unless current_author
      push_redirect_back_url
      redirect_to new_author_path
    end
  end

  def auth_visitor!
    redirect_to root_path if current_user
  end

  def push_redirect_back_url
    session[:redirect_back_url] = request.original_url
  end

  def pop_redirect_back_url
    if session[:redirect_back_url]
      url = session[:redirect_back_url]
      session[:redirect_back_url] = nil
      url
    end
  end
end
