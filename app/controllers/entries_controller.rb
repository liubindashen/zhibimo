class EntriesController < ApplicationController
  before_action :set_book, only: [:create, :show, :update, :destroy]

  def create
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end
end
