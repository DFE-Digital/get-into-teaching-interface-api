class API::LookupItems::TeachingSubjectsController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      crm_client.lookup_items.teaching_subjects.all
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
