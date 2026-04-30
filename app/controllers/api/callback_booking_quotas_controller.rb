class API::CallbackBookingQuotasController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      crm_client.callback_booking_quotas.all
    end
    render json: { data: data }
  end

  private

  def crm_client
    CRM::Client.new
  end
end
