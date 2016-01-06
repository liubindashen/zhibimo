class AuthorsController < ApplicationController

  def index
    @authors = Author.all
  end

  def show
    @author = Author.find_by_username(params[:author])
    @books = @author.books.explored
  end
end
