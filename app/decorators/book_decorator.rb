class BookDecorator < Draper::Decorator
  delegate_all

  def author_name
    object.author.username
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

  def readme_html
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
    markdown.render(object.readme || "")
  end
end
