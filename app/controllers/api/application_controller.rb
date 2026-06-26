class API::ApplicationController < ActionController::API
  class NotAuthorisedError < StandardError; end
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include TokenAuth
  include Cacheable
  include ErrorHandling

  def render_errors(messages, status)
    render status:, json: {
      errors: messages.map { |message| { error: status.to_s.camelize, message: } },
    }
  end

  def render_error_objects(errors, status)
    render status:, json: {
      errors: errors.map do |error|
        {
          error: status.to_s.camelize,
          message: error.message,
          attribute: error.attribute,
        }
      end,
    }
  end
end
