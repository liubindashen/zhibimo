module Writer
  class TeamsController < BaseController
    before_action :set_book, if: Proc.new { params[:book_id] }
    def new
      @team = Team.new
      @authors = Author.where(id: @book.teams.collect(&:author_id))
    end

    def create
      @author = Author.find_by(pen_name: params[:pen_name])
      @team = Team.find_or_create_by(book: @book, author: @author, access_level: "40")
      if @team.save
        redirect_to :back, notice: '添加新成员成功'
      else
        redirect_to :back, alert: '添加新成员失败'
      end
    end
  end
end
