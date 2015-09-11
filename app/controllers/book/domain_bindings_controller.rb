class Book::DomainBindingsController < ApplicationController
  def show
    @domain = DomainBinding.find_by(domain: requst.host)
    @domain ? "" : redirect_to root_path
  end
end
