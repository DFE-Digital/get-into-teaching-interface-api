class API::ApplicationController < ::ApplicationController
  class NotAuthorisedError < StandardError; end
  include Cacheable
  include ErrorHandling
  # 'does apply rescue from wrong urls?'

  before_action :require_valid_api_token!

  rescue_from NotAuthorisedError, with: :render_unauthorised_error

  private

  def require_valid_api_token!
    return @current_api_token.update!(last_used_at: Time.zone.now) if valid_api_token?

    raise NotAuthorisedError, "Please provide a valid authentication token"
  end

  def valid_api_token?
    authenticate_with_http_token do |unhashed_token|
      @current_api_token = APIToken.find_by_unhashed_token(unhashed_token)
    end
  end

  def render_unauthorised_error(e)
    render status: :unauthorized, json: {
      errors: [
        {
          error: "Unauthorized",
          message: e.message,
        },
      ],
    }
  end
end
