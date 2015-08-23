module Writer
  class OrdersController < BaseController
    before_action :set_book, if: Proc.new { params[:book_id] }

    def index
      if view_on_book?
        @orders = @book.orders.to_a
        render 'show', layout: 'book'
      else
        @orders = current_author.orders.to_a
        @orders_by_book = @orders.group_by(&:book)
        render 'index'
      end
    end

    private
    def view_on_book?
      @book.present?
    end
  end
end
