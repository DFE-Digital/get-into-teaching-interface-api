require "rails_helper"

RSpec.describe "POST /api/teacher_training_adviser/matchbacks", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  let(:valid_attributes) do
    {
      email: "test@example.com",
      first_name: "First Name",
      last_name: "Last name",
      date_of_birth: "2000-01-01",
      reference: "ref",
    }
  end

  describe "when the request is valid" do
    let(:crm_response) { instance_double(Faraday::Response, body: { "matched" => true }) }
    let(:candidate_resource) do
      instance_double(CRM::Adapters::GetIntoTeaching::Resources::TeacherTrainingAdviser::Resource)
    end
    let(:crm_client) { instance_double(CRM::Client, teacher_training_adviser: candidate_resource) }

    before do
      allow(candidate_resource).to receive(:matchback).and_return(crm_response)
      allow(CRM::Client).to receive(:new).and_return(crm_client)
    end

    it "performs the matchback and returns the CRM response" do
      post(api_teacher_training_adviser_matchbacks_path,
           params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to eq({ "matched" => true })
    end
  end

  describe "when params are invalid" do
    let(:invalid_attributes) do
      { matchback: { email: "bad" } }
    end

    it "returns validation errors" do
      post(api_teacher_training_adviser_matchbacks_path,
           params: invalid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:bad_request)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to have_key("errors")
    end
  end
end
