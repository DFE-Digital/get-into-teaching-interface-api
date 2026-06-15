class API::ApplicationController < ActionController::API
  class NotAuthorisedError < StandardError; end
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include TokenAuth
  include Cacheable
  include ErrorHandling

  def render_error(message, status)
    render status:, json: {
      errors: [
        {
          error: status.to_s.camelize,
          message:,
        },
      ],
    }
  end
end
