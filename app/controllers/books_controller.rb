class BooksController < ApplicationController
  before_action :auth_author!
  before_action :set_book, only: [:show, :edit, :update]

  def index
    @books = scope
    redirect_to new_book_path if @books.empty?
  end

  def show
  end

  def new
    @book = Book.new
  end

  def edit
    render layout: false
  end

  def create
    @book = scope.new(book_params)

    if @book.save

    else

    end
  end

  def update
    @book.update(book_params)
  end

  private
  def set_book
    id_or_slug = params[:id].to_i
    if id_or_slug > 0
      @book = scope.find(id_or_slug)
    else
      @book = scope.find_by_slug(params[:id])
    end
  end

  def book_params
    params.require(:book).permit(:title, :slug, :cover)
  end

  def scope
    current_author.books
  end
end
