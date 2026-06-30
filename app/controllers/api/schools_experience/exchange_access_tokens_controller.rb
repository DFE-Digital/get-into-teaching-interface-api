class API::SchoolsExperience::ExchangeAccessTokensController < API::ApplicationController
  def create
    exchange = SchoolsExperience::ExchangeAccessToken.new(
      client:,
      request_params:
    )

    if data = exchange.call
      render status: 200, json: data
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
    params.permit(
      :access_token,
      :email,
      :first_name,
      :last_name,
      :date_of_birth,
      :reference,
    )
  end

  def client
    @client ||= CRM::Client.new(
      adapter: CRM::Adapters::GetIntoTeaching::Client.new(
        api_key: @current_api_token.crm_key,
      )
    )
  end
end
