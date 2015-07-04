class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  private

  def current_user
    @current_user ||= ::User.find_by_id(session[:user_id])
  end

  def auth_user!
    redirect_to signin_path unless current_user
  end

  def auth_visitor!
    redirect_to dashboard_root_path if current_user
  end
end
