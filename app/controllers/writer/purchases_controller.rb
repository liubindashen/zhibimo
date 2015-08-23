module Writer
  class PurchasesController < BaseController
    before_action :set_book

    def edit
    end

    def update
      @book.profit = :purchase
      if @book.update(book_params)
        flash[:notice] = '图书转付费阅读成功'
        redirect_to edit_writer_book_path(@book)
      else
        flash.now[:alert] = '图书转付费阅读失败'
        render :edit
      end
    end

    private

    def book_params
      params.require(:book).permit(:price)
    end
  end
end
