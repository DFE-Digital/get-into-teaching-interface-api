require "rails_helper"

RSpec.describe "API::SchoolsExperience::Candidates", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  let(:valid_attributes) do
    {
      email: "test@example.com",
      first_name: "John",
      last_name: "Doe",
      preferred_teaching_subject_id: "subject-1",
      address_line1: "123 Main St",
      address_city: "London",
      address_state_or_province: "London",
      address_postcode: "SW1A 1AA",
      telephone: "01234567890",
      has_dbs_certificate: true,
      accepted_policy_id: "policy-1",
    }
  end

  describe "GET /api/schools_experience/candidates" do
    it "returns a list of candidates" do
      get(api_schools_experience_candidates_path, params: { ids: %w[abc-123 def-456] }, headers:)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to be_an(Array)
    end
  end

  describe "POST /api/schools_experience/candidates" do
    describe "when the request is valid" do
      it "creates the candidate and returns the response" do
        post(api_schools_experience_candidates_path,
             params: valid_attributes, headers:, as: :json)
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(%r{application/json})
        expect(response.parsed_body).to include("candidateId")
      end
    end

    describe "when params are invalid" do
      let(:invalid_attributes) do
        { email: "invalid" }
      end

      it "returns validation errors" do
        post(api_schools_experience_candidates_path,
             params: invalid_attributes, headers:, as: :json)
        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to match(%r{application/json})
        expect(response.parsed_body).to have_key("errors")
      end
    end

    describe "when the CRM is unavailable" do
      let(:schools_experience_resource) do
        instance_double(CRM::Adapters::GetIntoTeaching::Resources::SchoolsExperienceResource)
      end
      let(:crm_client) { instance_double(CRM::Client, schools_experience: schools_experience_resource) }

      before do
        allow(schools_experience_resource).to receive(:create_candidate)
                                              .and_raise(CRM::Adapters::GetIntoTeaching::Resource::Error)
        allow(CRM::Client).to receive(:new).and_return(crm_client)
      end

      it "returns 503" do
        post(api_schools_experience_candidates_path,
             params: valid_attributes, headers:, as: :json)
        expect(response).to have_http_status(:service_unavailable)
      end
    end
  end

  describe "GET /api/schools_experience/candidates/:id" do
    describe "when the candidate exists" do
      it "returns the candidate" do
        get(api_schools_experience_candidate_path("abc-123"), headers:)
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(%r{application/json})
        expect(response.parsed_body).to be_a(Hash)
      end
    end

    describe "when the candidate does not exist" do
      let(:schools_experience_resource) do
        instance_double(CRM::Resources::SchoolsExperienceResource)
      end
      let(:crm_client) { instance_double(CRM::Client, schools_experience: schools_experience_resource) }

      before do
        allow(schools_experience_resource).to receive(:find)
                                              .and_raise(CRM::Adapters::GetIntoTeaching::Resource::NotFoundError)
        allow(CRM::Client).to receive(:new).and_return(crm_client)
      end

      it "returns 404" do
        get(api_schools_experience_candidate_path("unknown-id"), headers:)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
