module Writer
  class DesksController < BaseController
    before_action :set_book

    def show
      @current_user = current_user
      gon.jbuilder

      render layout: 'desk'
    end
  end
end
