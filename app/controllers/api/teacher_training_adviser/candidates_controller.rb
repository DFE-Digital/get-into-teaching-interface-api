class API::TeacherTrainingAdviser::CandidatesController < ApplicationController
  def create
    if CreateCandidateJob.perform_later
      render status: 200
    else
      render status: 500, json: { error: "error message" }
    end
  end
end
