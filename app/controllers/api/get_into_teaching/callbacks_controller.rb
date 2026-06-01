class API::GetIntoTeaching::CallbacksController < API::ApplicationController
  def create
    render status: 200, json: { job_id: CallbackJob.perform_later.job_id }
    # Need to rename this endpoint from callbacks to teacher_training/candidates
  end
end
