class Book::DomainBindingsController < ApplicationController
  def show
    @domain = DomainBinding.find_by(domain: requst.host)
    @domain ? render "" : redirect_to root_path
  end
end
