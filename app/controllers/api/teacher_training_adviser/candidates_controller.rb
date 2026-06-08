class API::TeacherTrainingAdviser::CandidatesController < API::ApplicationController
  def create
    client = CRM::Client.new(
      adapter: CRM::Adapters::GetIntoTeaching::Client.new,
    )

    candidate = TeacherTrainingAdviser::Candidate.new(
      client:,
      request_params:
    )

    if candidate.create
      render status: 200, json: { response: "OK" }
    else
      errors = candidate.errors.map { |error| "#{error.attribute} #{error.message}" }
      render status: 500, json: { errors: }
    end
  end

  private

  def request_params
    params.expect(
      candidate: TeacherTrainingAdviser::Candidate::ATTRIBUTES
    )
  end
end
