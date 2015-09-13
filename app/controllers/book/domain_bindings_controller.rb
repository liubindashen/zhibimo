class Book::DomainBindingsController < ApplicationController
  layout 'domain_buiding'
  def index
    @domain = DomainBinding.find_by(domain: request.host)
    @url = @domain.domain_bindingtable.read_base_path  if @domain
  end
end
