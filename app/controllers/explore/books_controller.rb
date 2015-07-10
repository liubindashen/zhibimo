module Explore
  class BooksController < BaseController
    def index
      @books = scope.decorate
    end

    def show
      @book = scope.find_by_slug(params[:id]).decorate
    end

    private
    def scope
      Book.explored
    end
  end
end
