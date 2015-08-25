class UsersController < ApplicationController
  before_action :auth_user!

  def edit
  end

  def update
    if current_user.confirm(user_params)
      flash[:notice] = '注册成功，欢迎使用知笔墨。'
      redirect_to explore_books_path
    else
      flash.now[:alert] = '此用户名已被占用或不符合设定规则（数字、英文字符、横线与下划线），请更换后重试。'
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email)
  end
end
