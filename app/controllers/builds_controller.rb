class BuildsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @book = Book.find params[:book_id]
    BuildBookJob.perform_later(@book.id)
    redirect_to book_path(@book), notice: '成功加入构建队列'
  end

  def hook
    @book = Book.find_by_gitlab_id(params['project_id'])
    BuildBookJob.perform_later(@book.id)
    render nothing: true
  end
end
