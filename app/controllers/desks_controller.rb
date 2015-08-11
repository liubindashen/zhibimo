class DesksController < ApplicationController
  before_action :auth_author!

  def show
    @current_user = current_user
    @book = current_author.books.find params[:book_id]
    gon.jbuilder

    render layout: 'desk'
  end
end

