module Writer
  class DesksController < BaseController
    before_action :set_book

    def show
      if @book.other_git != ""
        @current_user = current_user
        gon.jbuilder

        render layout: 'desk'
      else
        redirect_to writer_books_path
      end
    end
  end
end
