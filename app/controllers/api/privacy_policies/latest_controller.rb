class API::PrivacyPolicies::LatestController < API::ApplicationController
  def show
    data = Rails.cache.fetch(**cache_options.to_h) do
      crm_client.privacy_policies.find("latest")
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

  def not_found_resource_name = "privacy_policies"
  def not_found_id = "latest"
end
