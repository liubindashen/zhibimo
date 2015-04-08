class ExploreController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find_by_slug(params[:id])
  end
end
