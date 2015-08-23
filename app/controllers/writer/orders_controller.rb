module Writer
  class OrdersController < BaseController
    before_action :set_book, if: Proc.new { params[:book_id] }

    def index
      if view_on_book?
        @orders = @book.orders
        @orders_with_complete = @orders.complete
        render 'show', layout: 'book'
      else
        @orders = current_author.orders
        @orders_by_book = @orders.group_by(&:book)
        @orders_with_complete = @orders.complete
        render 'index'
      end
    end

    private
    def view_on_book?
      @book.present?
    end
  end
end
