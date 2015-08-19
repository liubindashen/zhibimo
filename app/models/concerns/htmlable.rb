module Htmlable
  extend ActiveSupport::Concern

  included do
    def markdown
      @render ||= SummaryRender.new(base_url: html_base_url)
      @markdown ||= Redcarpet::Markdown.new(@render)
    end
  end

  module ClassMethods
    def html_attributes(*attrs)
      attrs.each do |attr|
        define_method("#{attr}_html") do
          markdown.render(self[attr] || "")
        end
      end
    end
  end
end
