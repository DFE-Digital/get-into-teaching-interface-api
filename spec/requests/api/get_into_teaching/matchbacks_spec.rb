require "rails_helper"

RSpec.describe "POST /api/get_into_teaching/matchbacks", type: :request do
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
    let(:crm_response) do
      CRM::Resources::GetIntoTeaching::CandidateResource.new(
        candidate_id: "abc-123", accepted_policy_id: nil, email: "test@example.com",
        first_name: nil, last_name: nil, address_telephone: nil,
        phone_call_scheduled_at: nil, talking_points: nil,
        creation_channel_source_id: nil, creation_channel_service_id: nil,
        creation_channel_activity_id: nil, default_contact_creation_channel: nil,
        default_creation_channel_source_id: nil, default_creation_channel_service_id: nil,
        default_creation_channel_activity_id: nil
      )
    end
    let(:get_into_teaching_resource) do
      instance_double(CRM::Adapters::GetIntoTeaching::Resources::GetIntoTeachingResource)
    end
    let(:crm_client) { instance_double(CRM::Client, get_into_teaching: get_into_teaching_resource) }

    before do
      allow(get_into_teaching_resource).to receive(:matchback).and_return(crm_response)
      allow(CRM::Client).to receive(:new).and_return(crm_client)
    end

    it "performs the matchback and returns the CRM response" do
      post(api_get_into_teaching_matchbacks_path,
           params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to include("candidate_id" => "abc-123")
    end
  end

  describe "when params are invalid" do
    let(:invalid_attributes) { { email: "bad" } }

    it "returns validation errors" do
      post(api_get_into_teaching_matchbacks_path,
           params: invalid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:bad_request)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to have_key("errors")
    end
  end
end
