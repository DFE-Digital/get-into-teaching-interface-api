class API::ApplicationController < ActionController::API
  class NotAuthorisedError < StandardError; end
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include TokenAuth
  include Cacheable
  include ErrorHandling
end
