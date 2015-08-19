module Reader
  class BaseController < ::ApplicationController
    before_action :auth_user!
  end
end
