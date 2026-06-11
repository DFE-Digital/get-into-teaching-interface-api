require "rails_helper"

RSpec.describe "POST /api/teacher_training_adviser/exchange_access_tokens", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  let(:valid_attributes) do
    {
      access_token: "123456",
      email: "test@example.com",
      first_name: "First Name",
      last_name: "Last name",
      date_of_birth: "2000-01-01",
    }
  end

  describe "when the request is valid" do
    let(:crm_response) { instance_double(Faraday::Response, body: { response: "OK" }) }
    let(:tta_resource) do
      instance_double(CRM::Adapters::GetIntoTeaching::Resources::TeacherTrainingAdviser::Resource)
    end
    let(:crm_client) { instance_double(CRM::Client, teacher_training_adviser: tta_resource) }

    before do
      allow(tta_resource).to receive(:exchange_access_token).and_return(crm_response)
      allow(CRM::Client).to receive(:new).and_return(crm_client)
    end

    it "exchanges the access token and returns the CRM response" do
      post(api_teacher_training_adviser_exchange_access_tokens_path,
           params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to eq({ "candidateId" => "abc-123", "email" => "test@example.com" })
    end
  end

  describe "when params are invalid" do
    let(:invalid_attributes) { { email: "bad" } }

    it "returns validation errors" do
      post(api_teacher_training_adviser_exchange_access_tokens_path,
           params: invalid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:bad_request)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to have_key("errors")
    end
  end
end
