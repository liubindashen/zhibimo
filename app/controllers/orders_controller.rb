class OrdersController < ApplicationController
  before_action :auth_author!
  before_action :set_book

  def index
    @orders = @book.orders
  end

  private
  def set_book
    @book = current_author.books.find params[:book_id]
  end
end

