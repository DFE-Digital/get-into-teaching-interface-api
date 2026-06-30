require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::TeachingEventsResource do
  let(:client) { CRM::Adapters::GetIntoTeaching::Client.new(api_key: "test-api-key") }

  subject(:resource) { described_class.new(client) }

  describe "#all", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/teaching_events/search" } do
    let(:params) { { typeIds: "222750012", startAfter: "2025-01-01" } }

    it "returns an array of events with symbolized underscored keys" do
      events = resource.all(params)
      expect(events).to be_an(Array)
      expect(events).not_to be_empty

      event = events.first
      expect(event).to include(
        type_id: Integer,
        status_id: Integer,
        readable_id: String,
        name: String,
        start_at: String,
        end_at: String,
        id: String,
      )
    end

    it "includes building info when present" do
      events = resource.all(params)
      event_with_building = events.find { |e| e[:building].present? }

      expect(event_with_building[:building]).to include(
        venue: String,
        address_line1: String,
        address_city: String,
        address_postcode: String,
        id: String,
      )
    end

    it "includes accessibility_options when present" do
      events = resource.all(params)
      event_with_accessibility = events.find { |e| e[:accessibility_options].present? }

      expect(event_with_accessibility[:accessibility_options]).to be_an(Array)
      expect(event_with_accessibility[:accessibility_options]).not_to be_empty
    end
  end

  describe "#find", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/teaching_events/find" } do
    let(:id) { "250930-get-into-teaching-north-event" }

    it "returns a single event with symbolized underscored keys" do
      event = resource.find(id)
      expect(event).to include(
        type_id: Integer,
        status_id: Integer,
        readable_id: String,
        name: String,
        start_at: String,
        end_at: String,
        id: String,
      )
    end
  end

  describe "#create", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/teaching_events/create" } do
    let(:body) do
      {
        typeId: 222_750_012,
        statusId: 222_750_000,
        readableId: "test-event-123",
        name: "Test Event",
        startAt: "2026-12-01T09:00:00",
        endAt: "2026-12-01T17:00:00",
      }
    end

    it "creates an event and returns the created event data" do
      event = resource.create(body)
      expect(event).to include(
        type_id: Integer,
        status_id: Integer,
        readable_id: String,
        name: String,
        start_at: String,
        end_at: String,
        id: String,
      )
    end
  end

  describe "#create_attendee", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/teaching_events/create_attendee" } do
    let(:body) do
      {
        eventId: "6a1f3a0f-9c76-f011-b4cb-7c1e5283b7df",
        email: "johndoe@example.com",
        firstName: "John",
        lastName: "Doe",
        acceptedPolicyId: "4872c8ed-0229-f111-8342-7c1e5285e3ab",
      }
    end

    it "returns a Faraday response" do
      response = resource.create_attendee(body)
      expect(response).to be_a(Faraday::Response)
    end
  end

  describe "#exchange_unverified_request", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/teaching_events/exchange_unverified_request" } do
    let(:body) do
      {
        event_id: "123e4567-e89b-12d3-a456-426614174000",
        email: "johndoe@example.com",
        first_name: "John",
        last_name: "Doe",
        accepted_policy_id: "4872c8ed-0229-f111-8342-7c1e5285e3ab",
        candidate_id: "d85a2f0b-290f-4931-98e2-e7d817ac38f3",
        qualification_id: "13da3277-c8ba-4b64-a79e-b0a3960c26be",
        channel_id: 222_750_049,
        creation_channel_source_id: 222_750_000,
        creation_channel_service_id: 222_750_010,
        creation_channel_activity_id: 222_750_017,
        preferred_teaching_subject_id: "b02655a1-2afa-e811-a981-000d3a276620",
        consideration_journey_stage_id: 222_750_000,
        degree_status_id: 222_750_000,
        address_postcode: "BN1 1AA",
        address_telephone: "07735 111111",
        is_verified: false,
        is_walk_in: false,
        subscribe_to_mailing_list: false,
        already_subscribed_to_events: false,
        already_subscribed_to_mailing_list: false,
        already_subscribed_to_teacher_training_adviser: false,
        accessibility_needs_for_event: "Wheelchair accessible space required",
      }
    end

    it "returns a hash with candidate data" do
      result = resource.exchange_unverified_request(body)
      expect(result).to be_a(Hash)
      expect(result[:candidate_id]).to be_present
    end
  end

  describe "#exchange_access_token", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/teaching_events/exchange_access_token" } do
    let(:token) { "877483" }
    let(:body) do
      {
        email: "johndoe@example.com",
      }
    end

    it "returns a hash with candidate data" do
      result = resource.exchange_access_token(token, body)
      expect(result).to be_a(Hash)
      expect(result[:candidate_id]).to be_present
    end
  end
end
