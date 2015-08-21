class SummaryRender < Redcarpet::Render::HTML
  def initialize(base_url: "")
    @base_url = base_url
    super
  end

  def header(text, header_level)
    # render empty
  end

  def list(contents, list_type)
    "<div class='ui relaxed divided list'>#{contents}</div>"
  end

  def list_item(text, list_type)
    "<div class='item'>#{text}</div>"
  end

  def link(link, title, content)
    # link = 'index.md' if link == 'README.md'
    # "<a href='#{@base_url}#{link.gsub(/\.md$/, '.html')}' target='_blank'>#{content}</a>"
    "<span>#{content}</span>"
  end
end
