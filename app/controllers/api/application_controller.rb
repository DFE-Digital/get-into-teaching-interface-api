class API::ApplicationController < ::ApplicationController
  include Cacheable
  include ErrorHandling
  skip_forgery_protection
end
