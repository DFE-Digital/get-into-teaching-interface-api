class API::OperationsController < API::ApplicationController
  def health_check
    render json: client.operations.health_check
  end

private

  def client
    @client ||= CRM::Client.new(
      adapter: CRM::Adapters::GetIntoTeaching::Client.new(
        api_key: @current_api_token.crm_key,
      )
    )
  end
end
