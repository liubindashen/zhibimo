class AuthorsController < ApplicationController
  before_action :auth_author!, only: [:edit, :update]
  before_action :auth_not_author!, only: [:new, :create]

  def new
    @author = Author.new
  end

  def create
    @author = current_user.build_author(author_params)

    if @author.save
      redirect_to go_back_url, notice: '创建成功'
    else
      render 'new'
    end
  end

  def edit
    @author = current_author
  end

  def update
    @author = current_author

    if @author.update_attributes(author_params)
      redirect_to edit_author_path(@author), notice: '保存成功'
    else
      render :edit
    end
  end

  private
  def auth_not_author!
    auth_user!
    redirect_to go_back_url if current_author
  end

  def author_params
    params.require(:author).permit(:pen_name, :intro, :slogan)
  end

  def go_back_url
    pop_redirect_back_url || root_path
  end
end
