module Writer
  class BooksController < BaseController
    layout 'book', only: [:edit, :update]

    before_action :set_book, only: [:edit, :update, :destroy]

    def index
      @books = scope.order('updated_at desc')
      redirect_to new_writer_book_path if @books.empty?
    end

    def new
      @book = scope.build
    end

    def edit
      load_domain
    end

    def create
      @book = scope.new(book_params)

      if @book.save
        flash[:notice] = '创建成功'
        redirect_to edit_writer_book_path(@book)
      else
        flash.now[:alert] = '创建失败'
        render 'new'
      end
    end

    def destroy
      if @book.price
        flash.now[:alert] = '收费图书不可以删除'
        redirect_to edit_writer_book_path(@book)
      else
        @book.destroy
        redirect_to writer_books_path
      end
    end

    def update
      if @book.update(book_params_for_update) && update_domain
        flash[:notice] = '更新成功'
        redirect_to edit_writer_book_path(@book)
      else
        error = @book.errors.full_messages
        flash.now[:alert] = error
        render 'edit'
      end
    end

    private
    def book_params_for_update
      params.require(:book).permit(:title, :intro, :profit, :price, :donate, :tag_list)
    end

    def book_params
      params.require(:book).permit(:title, :slug, :cover, :intro, :profit, :price, :donate)
    end

    def load_domain
      @domain = DomainBinding.find_or_create_by(domain_bindingtable: @book)
    end

    def update_domain
      load_domain
      @domain.update(domain: params[:book][:domain_binding_attributes][:domain])
    end

  end
end
