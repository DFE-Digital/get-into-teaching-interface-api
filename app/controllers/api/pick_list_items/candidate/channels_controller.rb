class API::PickListItems::Candidate::ChannelsController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      crm_client.pick_list_items.candidate.channels.all
    end
    render json: { data: data }
  end

  private

  def crm_client
    CRM::Client.new
  end
end
