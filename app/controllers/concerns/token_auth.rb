module TokenAuth
  class NotAuthorisedError < StandardError; end

  extend ActiveSupport::Concern

  included do
    before_action :require_valid_api_token!

    rescue_from NotAuthorisedError do |exception|
      render_errors([ exception.message ], :unauthorized)
    end
  end

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
end
