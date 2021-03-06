module Writer
  class CoversController < BaseController
    layout 'book'
    before_action :set_book, only: [:edit, :update]

    def edit
    end

    def update
      if @book.update(cover_params)
        flash[:notice] = '图书封面更新成功'
        redirect_to edit_writer_book_covers_path(@book)
      else
        flash.now[:alert] = '图书封面更新失败'
        render 'edit'
      end
    end

    private
    def cover_params
      params.require(:book).permit(:cover)
    end
  end
end
