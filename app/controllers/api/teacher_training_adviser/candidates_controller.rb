class API::TeacherTrainingAdviser::CandidatesController < API::ApplicationController
  def create
    candidate = TeacherTrainingAdviser::Candidate.new(
      client:,
      request_params:
    )

    if data = candidate.create
      render status: 200, json: data
    else
      messages = candidate.errors.map do |error|
        "#{error.attribute} #{error.message}"
      end
      render_errors(messages, :bad_request)
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
