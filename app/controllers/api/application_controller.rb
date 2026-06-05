class API::ApplicationController < ::ApplicationController
  class NotAuthorisedError < StandardError; end
  include TokenAuth
  include Cacheable
  include ErrorHandling
end
