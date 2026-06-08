class API::ApplicationController < ::ApplicationController
  class NotAuthorisedError < StandardError; end
  include TokenAuth
  include Cacheable
  include ErrorHandling
  ## need to come back to this
  skip_forgery_protection
end
