module Writer
  class BooksController < BaseController
    before_action :set_book, only: [:edit, :update]

    def index
      @books = scope.order('updated_at desc')
      redirect_to new_writer_book_path if @books.empty?
    end

    def new
      @book = scope.build
    end

    def edit
    end

    def create
      @book = scope.new(book_params)

      if @book.save
        redirect_to edit_writer_book_path(@book), notice: '创建成功'
      else
        render 'new'
      end
    end

    def update
      if @book.update(book_params)
        redirect_to edit_writer_book_path(@book), notice: '更新成功'
      else
        render 'show'
      end
    end

    private
    def set_book
      id = params[:id] || params[:book_id]
      id_or_slug = id.to_i
      if id_or_slug > 0
        @book = scope.find(id_or_slug)
      else
        @book = scope.find_by_slug(id)
      end
    end

    def book_params
      params.require(:book).permit(:title, :slug, :cover, :intro, :profit, :price, :donate)
    end

    def scope
      current_author.books
    end
  end
end
