class BuildsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    if params[:user_id] && params[:project_id]
      author = Author.find_by_gitlab_id params['user_id']
      book = author && author.books.find_by_gitlab_id params['project_id']
      BuildBookJob.perform_later(book.id)
    else
      BuildBookJob.perform_later(Book.find params[:id])
    end
  end
end
