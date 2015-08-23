module Writer
  class CoversController < BaseController
    layout 'book'
    before_action :set_book, only: [:edit, :update]

    def edit
    end

    def update
      if @book.update(book_params)
        flash[:notice] = '更新成功'
        redirect_to edit_writer_book_path(@book)
      else
        flash.now[:alert] = '更新失败'
        render 'edit'
      end
    end

    private
    def book_params
      params.require(:book).permit(:cover)
    end
  end
end
