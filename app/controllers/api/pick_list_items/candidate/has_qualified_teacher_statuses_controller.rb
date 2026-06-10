class API::PickListItems::Candidate::HasQualifiedTeacherStatusesController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      crm_client.pick_list_items.candidate.has_qualified_teacher_statuses.all
    end
    render json: data
  end

  private

  def crm_client
    CRM::Client.new
  end
end
