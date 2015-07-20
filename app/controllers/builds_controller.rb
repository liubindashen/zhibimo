class BuildsController < ApplicationController
  before_action :auth_author!
  protect_from_forgery :only => [:hook]

  def index
    @book = current_author.books.find params[:book_id]
  end

  def update
    book = current_author.books.find params[:book_id]
    BuildJob.perform_later(book.builds.find(params[:id]).id)
    redirect_to book_builds_path(@book, notice: '构建已加入队列，请等待。')
  end

  # "object_kind"=>"push", 
  # "before"=>"d0967338b6b719d90e251323acde712d6513dd62", 
  # "after"=>"a22fecaf3acc70ebbd33326891fd1714bd476216", 
  # "ref"=>"refs/heads/master", 
  # "checkout_sha"=>"a22fecaf3acc70ebbd33326891fd1714bd476216",
  # "message"=>nil,
  # "user_id"=>254,
  # "user_name"=>"邱亮",
  # "user_email"=>"qiu-liang@zhibimo.com",
  # "project_id"=>233

  # "repository"=>{"name"=>"test-book-ii", "url"=>"git@git.zhibimo.com:qiu-liang/test-book-ii.git", "description"=>nil, "homepage"=>"http://git.zhibimo.com/qiu-liang/test-book-ii", "git_http_url"=>"http://git.zhibimo.com/qiu-liang/test-book-ii.git", "git_ssh_url"=>"git@git.zhibimo.com:qiu-liang/test-book-ii.git", "visibility_level"=>0}

  # "commits"=>[{"id"=>"a22fecaf3acc70ebbd33326891fd1714bd476216", "message"=>"test\n", "timestamp"=>"2015-07-15T15:50:52+08:00", "url"=>"http://git.zhibimo.com/qiu-liang/test-book-ii/commit/a22fecaf3acc70ebbd33326891fd1714bd476216", "author"=>{"name"=>"hpyhacking", "email"=>"crazyflapjack@gmail.com"}}]
  
  def hook
    book = Book.find_by_gitlab_id(params['project_id'])

    if book && params['object_kind'] == 'push'
      commit = params['commits'].last

      build = book.builds.create! \
        name: book.author.pen_name,
        email: book.author.email,
        message: commit['message'],
        commit: params['checkout_sha'],
        at: DateTime.parse(commit['timestamp'])

      BuildJob.perform_later(build.id)
    end

    render nothing: true
  end
end
