class PurchasesController < ApplicationController
  before_action :auth_author!
  before_action :set_book

  def edit
  end

  def update
    @book.profit = :purchase
    if @book.update(book_params)
      redirect_to edit_book_path(@book), notice: '图书转付费阅读成功。'
    else
      render :edit
    end
  end

  private

  def book_params
    params.require(:book).permit(:price)
  end

  def scope
    current_author.books
  end

  def set_book
    @book = scope.find(params[:book_id])
  end
end
