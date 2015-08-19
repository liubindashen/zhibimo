module Reader
  class DonatesController < BaseController
    before_action :check_book_donate!

    def new
    end

    def create
      fee = params[:fee].to_d

      return redirect_to new_reader_book_donate_path(@book) unless fee > 0

      order = Order.create! \
        id: DateTime.now.strftime('%y%m%d%H%M%S%L%3N'),
        book: @book,
        purchaser: current_user, 
        fee: fee,
        author: @book.author, 
        profit: @book.profit

      req_params = {
        body: "#{@book.title} - 捐赠",
        out_trade_no: order.id, 
        total_fee: (fee * 100).to_i,
        spbill_create_ip: '127.0.0.1',
        trade_type: 'NATIVE',
        notify_url: Rails.application.routes.url_helpers.callback_reader_book_donate_path(@book, order, host: 'zhibimo.com')
      }

      result = WxPay::Service.invoke_unifiedorder req_params

      order.update_attributes \
        wx_prepay_id: result["prepay_id"],
        wx_code_url: result["code_url"]

      RQRCode::QRCode.new( result["code_url"], :size => 5, :level => :h )
        .to_img.resize(200, 200)
        .save("public/uploads/qrcode/#{order.id}.png")

      redirect_to reader_book_donate_path(@book, order)
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

    def callback
      result = Hash.from_xml(request.body.read)["xml"]
      if WxPay::Sign.verify?(result)

        if result['trade_state'] == 'SUCCESS'
          @order = Order.find result['out_trade_no']
          @order.done! if @order.may_done?
        end

        render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
      else
        render :xml => {return_code: "SUCCESS", return_msg: "签名失败"}.to_xml(root: 'xml', dasherize: false)
      end
    end

    private
    def check_book_donate!
      @book = Book.find(params[:book_id])
      redirect_to book_path(@book) unless (@book.free? and @book.donate)
    end
  end
end
