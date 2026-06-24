require "rails_helper"

RSpec.describe "POST /api/get_into_teaching/candidates/exchange_access_token", type: :request do
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
    let(:crm_response) do
      CRM::Resources::GetIntoTeaching::CandidateResource.new(
        candidate_id: "0a857c51-696c-4b02-ba71-75b31ccef673",
        accepted_policy_id: nil,
        email: "johndoe@example.com",
        first_name: "john",
        last_name: "doe",
        address_telephone: nil,
        phone_call_scheduled_at: nil,
        talking_points: nil,
        creation_channel_source_id: nil,
        creation_channel_service_id: nil,
        creation_channel_activity_id: nil,
        default_contact_creation_channel: 222750043,
        default_creation_channel_source_id: 222750003,
        default_creation_channel_service_id: 222750007,
        default_creation_channel_activity_id: nil,
      )
    end
    let(:get_into_teaching_resource) do
      instance_double(CRM::Adapters::GetIntoTeaching::Resources::GetIntoTeachingResource)
    end
    let(:crm_client) { instance_double(CRM::Client, get_into_teaching: get_into_teaching_resource) }

    before do
      allow(get_into_teaching_resource).to receive(:exchange_access_token).and_return(crm_response)
      allow(CRM::Client).to receive(:new).and_return(crm_client)
    end

    it "exchanges the access token and returns the CRM response" do
      post(api_get_into_teaching_exchange_access_token_path(access_token: "123456"),
           params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to include(
        "candidate_id" => "0a857c51-696c-4b02-ba71-75b31ccef673",
        "email" => "johndoe@example.com",
      )
    end
  end

  describe "when params are invalid" do
    let(:invalid_attributes) { { email: "bad" } }

    it "returns validation errors" do
      post(api_get_into_teaching_exchange_access_token_path(access_token: "x"),
           params: invalid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:bad_request)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to have_key("errors")
    end
  end
end
