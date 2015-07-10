module Explore
  class AuthorsController < BaseController
    def show
      @author = User.find_by_username(params[:id]).author
      @hot_books = @author.books.explored.first(3)
      @new_books = @author.books.explored.last(3)
    end
  end
end
