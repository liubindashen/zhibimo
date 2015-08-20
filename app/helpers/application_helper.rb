module ApplicationHelper
  def book_path(book)
    "/books/#{book.author_username}/#{book.slug}"
  end

  def author_path(book)
    "/books/#{book.author_username}"
  end

  def author_name(book)
    book.author.pen_name
  end

  def html_path(book)
    book.read_base_path
  end

  def title(page_title)
    content_for :title, page_title.to_s
  end

  def avatar(user = current_user)
    if user.author && !user.author.avatar.blank?
      user.author.avatar
    else
      user.avatar
    end
  end
end
