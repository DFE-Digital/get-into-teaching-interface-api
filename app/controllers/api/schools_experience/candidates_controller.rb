class API::SchoolsExperience::CandidatesController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      client.schools_experience.all
    end
    render json: data
  end

  def show
    data = Rails.cache.fetch(**cache_options.to_h) do
      client.schools_experience.find(params[:id])
    end
    render json: data
  end

  def create
    candidate = SchoolsExperience::Candidate.new(
      client:,
      request_params:
    )

    if response = candidate.create
      render status: 201, json: response.body
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
      SchoolsExperience::Candidate::ATTRIBUTES.map { |attr| attr[:name] }
    )
  end

private

  def client
    @client ||= CRM::Client.new
  end
end
