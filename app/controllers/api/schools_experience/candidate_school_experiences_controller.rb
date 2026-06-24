class API::SchoolsExperience::CandidateSchoolExperiencesController < API::ApplicationController
  def create
    school_experience = SchoolsExperience::CandidateSchoolExperience.new(
      client:,
      request_params:
    )

    if response = school_experience.create
      render status: 204, json: response.body
    else
      messages = school_experience.errors.map do |error|
        "#{error.attribute} #{error.message}"
      end
      render_errors(messages, :bad_request)
    end
  end

  def request_params
    params.require([ :id ])
    params.permit(
      SchoolsExperience::CandidateSchoolExperience::ATTRIBUTES.map { |attr| attr[:name] }
    )
  end

private

  def client
    @client ||= CRM::Client.new(
      adapter: CRM::Adapters::GetIntoTeaching::Client.new,
    )
  end
end
