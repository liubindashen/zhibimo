class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_gon

  def set_gon
    if current_user
      gon.currentUser = {username: current_user.username}
    else
      gon.currentUser = nil
    end
  end

  def index
  end

  def editor
    render layout: 'editor'
  end

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def auth_author!
    unless current_user
      render json: {error: 'auth error'}, status: 500
    end
  end
end
