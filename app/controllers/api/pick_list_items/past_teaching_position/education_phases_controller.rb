class API::PickListItems::PastTeachingPosition::EducationPhasesController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      crm_client.pick_list_items.past_teaching_position.education_phases.all
    end
    render json: data
  end

  private

  def crm_client
    CRM::Client.new
  end
end
