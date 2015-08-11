module Api
  class EntriesController < ::ApplicationController
    before_action :auth_author!
    before_action :set_book
    before_action :set_entry, only: [:show, :update, :destroy]

    def index
      @entries = @book.entries
    end

    def show
      @entry.read
    end

    def update
      @entry.content = params[:content]
      @entry.write!

      render :show
    end

    def push
      @book.push_working_repo
      render nothing: true
    end

    def create
      @entry = Entry.new(@book, params[:path])
      if @entry.valid?
        @entry.touch!
        render :show
      else
      end
    end

    def destroy
      @entry.remove!
    end

    private
    def set_book
      @book ||= current_author.books.find(params[:book_id])
    end

    def set_entry
      set_book unless @book
      @entry ||= Entry.new(@book, params[:path])
    end
  end
end

