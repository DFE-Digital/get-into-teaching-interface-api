class API::PickListItems::Candidate::PreferredEducationPhasesController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      crm_client.pick_list_items.candidate.preferred_education_phases.all
    end
    render json: { data: data }
  end

  private

  def crm_client
    CRM::Client.new
  end
end
