class ApplicationController < ActionController::Base
  before_action :set_variant

  def set_variant
    if browser.tablet?
      request.variant = :tablet 
    elsif browser.mobile?
      request.variant = :mobile
    else
      request.variant = :desktop
    end
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def auth_author!
    redirect_to signin_path unless current_user
  end

  def auth_visitor!
    redirect_to explore_index_path if current_user
  end
end
