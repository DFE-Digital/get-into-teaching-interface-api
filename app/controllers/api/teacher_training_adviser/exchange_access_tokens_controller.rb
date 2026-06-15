class API::TeacherTrainingAdviser::ExchangeAccessTokensController < API::ApplicationController
  def create
    exchange = TeacherTrainingAdviser::ExchangeAccessToken.new(
      client:,
      request_params:
    )

    if response = exchange.call
      render status: 200, json: response.body
    else
      messages = exchange.errors.map do |error|
        "#{error.attribute} #{error.message}"
      end
      render_errors(messages, :bad_request)
    end
  end

  private

  def request_params
    params.require([ :access_token, :email ])
    params.permit(:access_token, :email, :first_name, :last_name, :date_of_birth)
  end

  def client
    @client ||= CRM::Client.new
  end
end
