require "rails_helper"

RSpec.describe "POST /api/candidates/access_tokens", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  let(:valid_attributes) do
    {
      email: "test@example.com",
      first_name: "First Name",
      last_name: "Last name",
      date_of_birth: "2000-01-01",
    }
  end

  describe "when the request is valid" do
    let(:crm_response) { instance_double(Faraday::Response, status: 204) }
    let(:candidate_resource) do
      instance_double(CRM::Adapters::GetIntoTeaching::Resources::CandidatesResource)
    end
    let(:crm_client) { instance_double(CRM::Client, candidates: candidate_resource) }

    before do
      allow(candidate_resource).to receive(:create_access_token).and_return(crm_response)
      allow(CRM::Client).to receive(:new).and_return(crm_client)
    end

    it "sends the request and gets CRM response" do
      post(api_candidates_access_tokens_path, params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(%r{application/json})
      expect(response.status).to eq(200)
    end
  end

  describe "when params are invalid" do
    let(:invalid_attributes) { { email: "bad" } }

    it "returns validation errors" do
      post(api_candidates_access_tokens_path, params: invalid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:bad_request)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to have_key("errors")
    end
  end
end
