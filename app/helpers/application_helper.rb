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

  def check_book_menu_item_active(item)
    item.to_s == @active_book_menu_item ? 'item active' : 'item'
  end

  def set_active_book_menu_item(item)
    @active_book_menu_item = item.to_s
  end

  def markdown_to_html(content, base_url = '')
    r = Redcarpet::Render::HTML.new(base_url: base_url)
    m = Redcarpet::Markdown.new(r)
    m.render(content || '')
  end

  def readme_to_html(book, base_url = '')
    r = ReadmeRender.new(base_url: book.read_base_path)
    m = Redcarpet::Markdown.new(r)
    m.render(book.readme || '')
  end

  def summary_to_html(book)
    r = SummaryRender.new(base_url: book.read_base_path)
    m = Redcarpet::Markdown.new(r)
    m.render(book.summary || '')
  end

  def fee(order_or_decimal)
    fee = if order_or_decimal.is_a? Order
            order_or_decimal.fee
          elsif order_or_decimal.is_a? BigDecimal
            order_or_decimal
          else
            order_or_decimal.to_a.sum(&:fee)
          end

    number_to_currency(fee.to_d)
  end

  def avatar(user = current_user)
    if user.author && !user.author.avatar.blank?
      user.author.avatar
    else
      user.avatar
    end
  end
end
