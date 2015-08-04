class OrdersController < ApplicationController
  before_action :auth_author!

  def index
    @orders = scope.orders
  end

  private
  def scope
    if params[:book_id]
      @book = current_author.books.find params[:book_id]
    else
      current_author
    end
  end
end

