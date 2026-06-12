class API::TeacherTrainingAdviser::CandidatesController < API::ApplicationController
  def create
    candidate = TeacherTrainingAdviser::Candidate.new(
      client:,
      request_params:
    )

    if candidate.create
      render status: 200, json: { response: "OK" }
    else
      errors = candidate.errors.map { |error| "#{error.attribute} #{error.message}" }
      render status: 400, json: { errors: }
    end
  end

  private

  def request_params
    params.permit(
      TeacherTrainingAdviser::Candidate::ATTRIBUTES.map { |attr| attr[:name] }
    )
  end

private

  def client
    @client ||= CRM::Client.new
  end
end
