class BookDecorator < Draper::Decorator
  delegate_all

  def author_pen_name
    object.author.pen_name
  end

  def basic_name
    "#{object.author.username}/#{object.slug}"
  end

  def html_url
    "/read/#{basic_name}/"
  end
  
  def pdf_url
    "/read/#{basic_name}.pdf"
  end

  def mobi_url
    "/read/#{basic_name}.mobi"
  end

  def epub_url
    "/read/#{basic_name}.epub"
  end

  def summary_html
    render = SummaryRender.new base_url: html_url
    markdown = Redcarpet::Markdown.new(render)
    markdown.render(object.summary || "")
  end
end
