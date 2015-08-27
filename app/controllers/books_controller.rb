class BooksController < ApplicationController
  def index
    @books = scope
  end

  def show
    push_redirect_back_url

    @book = Author
      .find_by_username(params[:author]).books
      .find_by_slug(params[:slug])
  end

  private
  def scope
    if params[:query]
      Book.explored.where('title LIKE ?', "%#{params[:query]}%")
    else
      Book.explored
    end
  end
end
