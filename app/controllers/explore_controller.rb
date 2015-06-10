class ExploreController < ApplicationController
  layout 'explore'

  def index
    @books = scope.decorate
    respond_to do |format|
      format.html do |html|
        html.phone
        html.tablet
        html.desktop
      end
    end
  end

  def show
    @book = scope.find_by_slug(params[:id]).decorate
    respond_to do |format|
      format.html do |html|
        html.phone
        html.tablet
        html.desktop
      end
    end
  end

  private
  def scope
    Book.explored
  end
end
