class API::TeachingEventBuildingsController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      crm_client.teaching_event_buildings.all
    end
    render json: data
  end

  private

  def crm_client
    CRM::Client.new
  end
end
