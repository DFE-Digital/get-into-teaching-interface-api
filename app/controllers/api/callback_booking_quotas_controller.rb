class API::CallbackBookingQuotasController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      crm_client.callback_booking_quotas.all
    end
    render json: data
  end

  private

  def crm_client
    @client ||= CRM::Client.new(
      adapter: CRM::Adapters::GetIntoTeaching::Client.new(
        api_key: @current_api_token.crm_key,
      )
    )
  end
end
