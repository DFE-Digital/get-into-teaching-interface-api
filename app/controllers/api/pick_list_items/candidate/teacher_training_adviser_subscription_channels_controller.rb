class API::PickListItems::Candidate::TeacherTrainingAdviserSubscriptionChannelsController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      crm_client.pick_list_items.candidate.teacher_training_adviser_subscription_channels.all
    end
    render json: data
  end

  private

  def crm_client
    CRM::Client.new
  end
end
