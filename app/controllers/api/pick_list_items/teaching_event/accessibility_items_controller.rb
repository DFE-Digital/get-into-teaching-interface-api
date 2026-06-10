class API::PickListItems::TeachingEvent::AccessibilityItemsController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      crm_client.pick_list_items.teaching_event.accessibility_items.all
    end
    render json: data
  end

  private

  def crm_client
    CRM::Client.new
  end
end
