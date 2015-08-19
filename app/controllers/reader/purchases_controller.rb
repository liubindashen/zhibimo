module Reader
  class PurchasesController < BaseController
    before_action :check_double_pay!

    def create
      fee = @book.price

      order = Order.create! \
        id: DateTime.now.strftime('%y%m%d%H%M%S%L%3N'),
        book: @book,
        purchaser: current_user, 
        fee: fee,
        author: @book.author, 
        profit: @book.profit

      req_params = {
        body: "#{@book.title} - 付费阅读",
        out_trade_no: order.id, 
        total_fee: (fee * 100).to_i,
        spbill_create_ip: '127.0.0.1',
        trade_type: 'NATIVE',
        notify_url: Rails.application.routes.url_helpers.callback_reader_book_purchase_path(@book, order, host: 'zhibimo.com')
      }

      result = WxPay::Service.invoke_unifiedorder req_params

      order.update_attributes \
        wx_prepay_id: result["prepay_id"],
        wx_code_url: result["code_url"]

      RQRCode::QRCode.new( result["code_url"], :size => 5, :level => :h )
        .to_img.resize(200, 200)
        .save("public/uploads/qrcode/#{order.id}.png")

      redirect_to reader_book_purchase_path(@book, order)
    end

    def show
      @order = current_user.orders.find params[:id]
      @book = @order.book

      return redirect_to book_path(@order.book) unless @order.may_wait?

      result = WxPay::Service.invoke_orderquery({out_trade_no: @order.id})

      if result['trade_state'] == 'SUCCESS'
        @order.done!
        redirect_to book_path(@order.book)
      end
    end

    private
    def check_double_pay!
      @book = Book.find params[:book_id]
    end
  end
end
