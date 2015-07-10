class AuthorsController < ApplicationController
  before_action :auth_not_author!, only: [:new, :create]
  before_action :auth_author!, only: [:edit, :update]

  def new
    @author = Author.new
  end

  def create
    current_user.create_author(author_params)
    redirect_to go_back_url
  end

  private
  def auth_not_author!
    redirect_to go_back_url if current_author 
  end

  def author_params
    params.require(:author).permit(:pen_name)
  end

  def go_back_url
    pop_redirect_back_url || root_path
  end
end
