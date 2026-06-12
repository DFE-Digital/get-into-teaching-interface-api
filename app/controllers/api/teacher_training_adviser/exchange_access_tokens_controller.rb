class API::TeacherTrainingAdviser::ExchangeAccessTokensController < API::ApplicationController
  def create
    exchange = TeacherTrainingAdviser::ExchangeAccessToken.new(
      client:,
      request_params:
    )

    if response = exchange.call
      render status: 200, json: response.body
    else
      errors = exchange.errors.map { |error| "#{error.attribute} #{error.message}" }
      render status: 400, json: { errors: }
    end
  end

  private

  def request_params
    params.require([ :access_token, :email ])
    params.permit(:access_token, :email, :first_name, :last_name, :date_of_birth)
  end

  def client
    @client ||= CRM::Client.new(
      adapter: CRM::Adapters::GetIntoTeaching::Client.new,
    )
  end
end
