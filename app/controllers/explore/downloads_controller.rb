module Explore
  class DownloadsController < BaseController
    def show
      @book = scope.find_by_slug(params[:id]).decorate
    end

    private
    def scope
      Book.explored
    end
  end
end