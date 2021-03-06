class AuthorsController < ApplicationController

  def index
    @authors = Author.all
  end

  def show
    @author = Author.find_by_username(params[:author])
    @hot_books = @author.books.explored.first(3)
  end
end
