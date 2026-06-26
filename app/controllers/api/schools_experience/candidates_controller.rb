class API::SchoolsExperience::CandidatesController < API::ApplicationController
  def index
    render json: client.schools_experience.all(ids: index_params)
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

    if data = candidate.create
      render status: 201, json: data
    else
      messages = candidate.errors.map do |error|
        "#{error.attribute} #{error.message}"
      end
      render_errors(messages, :bad_request)
    end
  end

  private

  def index_params
    params.expect(ids: [])
  end

  def request_params
    params.permit(
      SchoolsExperience::Candidate::ATTRIBUTES.map { |attr| attr[:name] }
    )
  end

  def client
    @client ||= CRM::Client.new(
      adapter: CRM::Adapters::GetIntoTeaching::Client.new,
    )
  end
end
