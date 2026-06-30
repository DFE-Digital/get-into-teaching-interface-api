class API::TeachingEvents::ExchangeUnverifiedRequestsController < API::ApplicationController
  def create
    exchange = TeachingEvents::ExchangeUnverifiedRequest.new(
      client:,
      request_params:
    )

    if response = exchange.call
      render status: 200, json: response
    else
      messages = exchange.errors.map do |error|
        "#{error.attribute} #{error.message}"
      end
      render_errors(messages, :bad_request)
    end
  end

  private

  def request_params
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
