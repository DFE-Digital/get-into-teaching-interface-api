class API::PickListItems::Candidate::InitialTeacherTrainingYearsController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      crm_client.pick_list_items.candidate.initial_teacher_training_years.all
    end
    render json: { data: data }
  end

  private

  def crm_client
    CRM::Client.new
  end
end
