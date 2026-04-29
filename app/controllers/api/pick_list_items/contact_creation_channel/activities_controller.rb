class API::PickListItems::ContactCreationChannel::ActivitiesController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      crm_client.pick_list_items.contact_creation_channel.activities.all
    end
    render json: { data: data }
  end

  private

  def crm_client
    CRM::Client.new
  end
end
