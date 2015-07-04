class BooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:hook]
  before_action :auth_user!, except: [:hook]
  before_action :set_book, only: [:show, :edit, :update, :destroy, :build]

  def build
    BuildBookJob.perform_later(@book.id)
    respond_to do |format|
      format.json { render json: {} }
      format.html { render json: {} }
    end
  end

  def hook
    @book = Book.from_hook(params)
    BuildBookJob.perform_later(@book.id)
    respond_to do |format|
      format.json { render json: {} }
      format.html { render json: {} }
    end
  end

  # GET /books
  # GET /books.json
  def index
    @books = current_user.books
    redirect_to new_book_path if @books.empty?
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
    render layout: false
  end

  # POST /books
  # POST /books.json
  def create
    @book = current_user.books.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      id_or_slug = params[:id].to_i
      if id_or_slug > 0
        @book = current_user.books.find(id_or_slug)
      else
        @book = current_user.books.find_by_slug(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :slug, :cover)
    end
end
