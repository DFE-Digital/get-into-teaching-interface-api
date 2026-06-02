class API::TeacherTrainingAdviser::CandidatesController < API::ApplicationController
  def create
    render status: 200, json: { job_id: CallbackJob.perform_later.job_id }
  end
end
