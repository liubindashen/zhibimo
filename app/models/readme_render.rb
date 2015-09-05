class ReadmeRender < Redcarpet::Render::HTML
  def initialize(base_url: "")
    @base_url = base_url
    super
  end

  def image(link, title, alt_text)
    unless link =~ /^http\:\/\//
      link = "#{@base_url}#{link}"
    end

    "<img src='#{link}' alt='#{alt_text}'></img>"
  end
end
