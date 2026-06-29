require "rails_helper"

RSpec.describe "POST /api/teaching_events/attendees/exchange_access_token/:access_token", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  let(:teaching_events_resource) do
    instance_double(CRM::Adapters::GetIntoTeaching::Resources::TeachingEventsResource)
  end
  let(:crm_client) { instance_double(CRM::Client, teaching_events: teaching_events_resource) }

  before do
    allow(CRM::Client).to receive(:new).and_return(crm_client)
  end

  let(:valid_attributes) do
    {
      email: "test@example.com",
      first_name: "John",
      last_name: "Doe",
    }
  end

  let(:response_data) do
    {
      event_id: "123e4567-e89b-12d3-a456-426614174000",
      email: "test@example.com",
      first_name: "John",
      last_name: "Doe",
      accepted_policy_id: "4872c8ed-0229-f111-8342-7c1e5285e3ab",
    }
  end

  before do
    allow(teaching_events_resource).to receive(:exchange_access_token).and_return(response_data)
  end

  describe "when the request is valid" do
    it "returns JSON" do
      post(api_teaching_events_exchange_access_token_path(access_token: "123456"),
           params: valid_attributes, headers:, as: :json)
      expect(response.content_type).to match(%r{application/json})
    end

    it "returns 200" do
      post(api_teaching_events_exchange_access_token_path(access_token: "123456"),
           params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:ok)
    end

    it "returns the pre-populated attendee data" do
      post(api_teaching_events_exchange_access_token_path(access_token: "123456"),
           params: valid_attributes, headers:, as: :json)
      expect(response.parsed_body).to include(
        "event_id" => "123e4567-e89b-12d3-a456-426614174000",
        "email" => "test@example.com",
      )
    end
  end

  describe "when params are invalid" do
    let(:invalid_attributes) { { email: "bad" } }

    it "returns 400" do
      post(api_teaching_events_exchange_access_token_path(access_token: "x"),
           params: invalid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:bad_request)
    end

    it "returns validation errors" do
      post(api_teaching_events_exchange_access_token_path(access_token: "x"),
           params: invalid_attributes, headers:, as: :json)
      expect(response.parsed_body).to have_key("errors")
    end
  end

  describe "when no auth token is provided" do
    it "returns 401" do
      post(api_teaching_events_exchange_access_token_path(access_token: "123456"),
           params: valid_attributes, as: :json)
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "when the CRM is unavailable" do
    before do
      allow(teaching_events_resource).to receive(:exchange_access_token)
        .and_raise(CRM::Adapters::GetIntoTeaching::Resource::Error)
    end

    it "returns 503" do
      post(api_teaching_events_exchange_access_token_path(access_token: "123456"),
           params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:service_unavailable)
    end
  end
end
