class API::ApplicationController < ::ApplicationController
  include Cacheable
  include ErrorHandling
end
