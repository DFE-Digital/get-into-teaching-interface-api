class API::PrivacyPoliciesController < API::ApplicationController
  def show
    data = Rails.cache.fetch(**cache_options.to_h) do
      crm_client.privacy_policies.find(params[:id])
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
