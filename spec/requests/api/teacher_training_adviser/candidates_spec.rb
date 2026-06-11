require "rails_helper"

RSpec.describe "POST /api/teacher_training_adviser/candidates", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  let(:valid_attributes) do
    {
      email: "test@example.com",
      first_name: "John",
      last_name: "Doe",
      date_of_birth: "1990-01-01",
      accepted_policy_id: "abc-123",
      country_id: "uk",
      type_id: "type-1",
    }
  end

  describe "when the request is valid" do
    let(:candidate_resource) do
      instance_double(CRM::Adapters::GetIntoTeaching::Resources::TeacherTrainingAdviser::Resource)
    end
    let(:crm_client) { instance_double(CRM::Client, teacher_training_adviser: candidate_resource) }

    before do
      allow(candidate_resource).to receive(:create_candidate).and_return(true)
      allow(CRM::Client).to receive(:new).and_return(crm_client)
    end

    it "creates the candidate and returns a success response" do
      post(api_teacher_training_adviser_candidates_path,
           params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to eq({ "response" => "OK" })
    end
  end

  describe "when params are invalid" do
    let(:invalid_attributes) do
      { candidate: { email: "bad" } }
    end

    it "returns validation errors" do
      post(api_teacher_training_adviser_candidates_path,
           params: invalid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:bad_request)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to have_key("errors")
    end
  end

  describe "when the CRM is unavailable" do
    let(:candidate_resource) do
      instance_double(CRM::Adapters::GetIntoTeaching::Resources::TeacherTrainingAdviser::Resource)
    end
    let(:crm_client) { instance_double(CRM::Client, teacher_training_adviser: candidate_resource) }

    before do
      allow(candidate_resource).to receive(:create_candidate)
                                    .and_raise(CRM::Adapters::GetIntoTeaching::Resource::Error)
      allow(CRM::Client).to receive(:new).and_return(crm_client)
    end

    it "returns 503" do
      post(api_teacher_training_adviser_candidates_path,
           params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:service_unavailable)
    end
  end
end
