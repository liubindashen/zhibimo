module Writer
  class BaseController < ::ApplicationController
    before_action :auth_author!
  end
end
