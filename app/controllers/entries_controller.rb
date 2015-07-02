class EntriesController < ApplicationController
  before_action :auth_user!
  before_action :set_book

  def index
    render json: @book.entries
  end

  def create
    @entry = @book.entry_create(params[:path])
    render json: @entry.to_json, status: :created
  end

  def show
    @entry = @book.entries.find(params[:id])
    render json: @entry.to_json
  end

  def update
    @entry = @book.entries.find(params[:id])
    #@entry.repo_update(params[:content], params[:message])
    render json: @entry.to_json
  end

  def destroy
    @entry = @book.entries.find(params[:id])
    @entry.destroy
    render json: {}
  end

  private

  def set_book
    id_or_slug = params[:book_id].to_i
    if id_or_slug > 0
      @book = current_user.books.find(params[:book_id])
    else
      @book = current_user.books.find_by_slug(params[:book_id])
    end
  end
end
