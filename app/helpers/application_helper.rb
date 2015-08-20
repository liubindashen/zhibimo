module ApplicationHelper
  def book_path(book)
    "/books/#{book.author_username}/#{book.slug}"
  end

  def author_path(book_or_author)
    username = if book_or_author.is_a? Author
                 book_or_author.username
               else
                 book_or_author.author_username
               end

    "/books/#{username}"
  end

  def author_name(book)
    book.author.pen_name
  end

  def html_path(book)
    book.read_base_path
  end

  def title(page_title)
    content_for :title, "#{page_title} - 知笔墨"
  end

  def avatar(user = current_user)
    if user.author && !user.author.avatar.blank?
      user.author.avatar
    else
      user.avatar
    end
  end
end
