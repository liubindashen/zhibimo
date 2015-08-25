class ApplicationController < ActionController::Base
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :current_author, \
    :push_redirect_back_url, :pop_redirect_back_url

  # global check username by user confirm !!!
  before_action :register_confirm!

  def register_confirm!
    if current_user 
      if !current_user.is_confirm? && controller_name != 'users'
        flash[:notice] = '登陆成功，请先完善个人信息。'
        return redirect_to register_path
      end

      # force redirect to books path when user confirmed
      if current_user.is_confirm? && controller_name == 'users'
        return redirect_to books_path
      end
    end
  end

  rescue_from(ActionController::ParameterMissing) do
    redirect_to '/500'
  end

  private

  def current_user
    @current_user ||= ::User.find_by_id(session[:user_id])
  end

  def current_author
    @current_author ||= (current_user && current_user.author)
  end

  def current_admin_user
    @admin_list ||= ENV['ADMIN_LIST'].split(',')
    @current_admin_user ||= if current_user && @admin_list.include?(current_user.username)
                              current_user
                            end
  end

  def auth_user!
    unless current_user
      push_redirect_back_url if request.request_method == 'GET'
      redirect_to signin_path 
    end
  end

  def auth_author!
    unless current_author
      push_redirect_back_url
      redirect_to new_writer_profile_path
    end
  end

  def auth_visitor!
    redirect_to root_path if current_user
  end

  def authenticate_admin_user!
    unless current_admin_user
      redirect_to root_path
    end
  end

  def push_redirect_back_url
    session[:redirect_back_url] = request.original_url
  end

  def pop_redirect_back_url
    if session[:redirect_back_url]
      url = session[:redirect_back_url]
      session[:redirect_back_url] = nil
      url
    else
      false
    end
  end
end
