class AuthorsController < ApplicationController
  def show
    @author = Author.find_by_username(params[:author])
    @hot_books = @author.books.explored.first(3)
    @new_books = @author.books.explored.last(3)
  end
end
