module Writer
  class BaseController < ::ApplicationController
    before_action :auth_author!

    def set_book
      @book = scope.find(params[:book_id] || params[:id])
    end

    def scope
      current_author.books
    end
  end
end
