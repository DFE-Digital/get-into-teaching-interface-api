require "rails_helper"

RSpec.describe "POST /api/teaching_events/attendees", type: :request do
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
      event_id: "123e4567-e89b-12d3-a456-426614174000",
      email: "johndoe@example.com",
      first_name: "John",
      last_name: "Doe",
      accepted_policy_id: "4872c8ed-0229-f111-8342-7c1e5285e3ab",
    }
  end

  before do
    allow(teaching_events_resource).to receive(:create_attendee).and_return(true)
  end

  describe "when the request is valid" do
    it "returns 204" do
      post api_teaching_events_attendees_path, params: valid_attributes, headers:, as: :json
      expect(response).to have_http_status(:no_content)
    end

    it "returns no content body" do
      post api_teaching_events_attendees_path, params: valid_attributes, headers:, as: :json
      expect(response.body).to be_empty
    end
  end

  describe "when params are invalid" do
    let(:invalid_attributes) { { email: "bad" } }

    it "returns 400" do
      post api_teaching_events_attendees_path, params: invalid_attributes, headers:, as: :json
      expect(response).to have_http_status(:bad_request)
    end

    it "returns validation errors" do
      post api_teaching_events_attendees_path, params: invalid_attributes, headers:, as: :json
      expect(response.parsed_body).to have_key("errors")
    end

    it "does not call the CRM" do
      post api_teaching_events_attendees_path, params: invalid_attributes, headers:, as: :json
      expect(teaching_events_resource).not_to have_received(:create_attendee)
    end
  end

  describe "when no auth token is provided" do
    it "returns 401" do
      post api_teaching_events_attendees_path, params: valid_attributes, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "when the CRM is unavailable" do
    before do
      allow(teaching_events_resource).to receive(:create_attendee)
        .and_raise(CRM::Adapters::GetIntoTeaching::Resource::Error)
    end

    it "returns 503" do
      post api_teaching_events_attendees_path, params: valid_attributes, headers:, as: :json
      expect(response).to have_http_status(:service_unavailable)
    end
  end

  describe "when the CRM returns a bad request" do
    let(:errors) do
      [
        CRM::Adapters::GetIntoTeaching::Resource::ErrorObjects.new(
          attribute: "event_id",
          message: "can't be blank",
        ),
      ]
    end

    before do
      allow(teaching_events_resource).to receive(:create_attendee)
        .and_raise(CRM::Adapters::GetIntoTeaching::Resource::BadRequestError.new(errors))
    end

    it "returns 400" do
      post api_teaching_events_attendees_path, params: valid_attributes, headers:, as: :json
      expect(response).to have_http_status(:bad_request)
    end

    it "returns structured error objects" do
      post api_teaching_events_attendees_path, params: valid_attributes, headers:, as: :json
      expect(response.parsed_body["errors"].first).to include(
        "error" => "BadRequest",
        "message" => "can't be blank",
        "attribute" => "event_id",
      )
    end
  end
end
