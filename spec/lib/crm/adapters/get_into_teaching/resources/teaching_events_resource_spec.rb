require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::TeachingEventsResource do
  let(:client) { CRM::Adapters::GetIntoTeaching::Client.new(api_key: "test-api-key") }

  subject(:resource) { described_class.new(client) }

  describe "#all", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/teaching_events/search" } do
    let(:params) { { typeIds: "222750012", startAfter: "2025-01-01" } }

    it "returns an array of TeachingEvents::Resource instances" do
      events = resource.all(params)
      expect(events).to be_an(Array)
      expect(events).not_to be_empty
      expect(events.first).to be_a(CRM::Resources::TeachingEvents::Resource)
    end

    it "includes building info when present" do
      events = resource.all(params)
      event_with_building = events.find { |e| e.building.present? }

      expect(event_with_building.building).to be_a(CRM::Resources::TeachingEvents::BuildingResource)
      expect(event_with_building.building.venue).to be_a(String)
    end

    it "includes accessibility_options when present" do
      events = resource.all(params)
      event_with_accessibility = events.find { |e| e.accessibility_options.present? }

      expect(event_with_accessibility.accessibility_options).to be_an(Array)
      expect(event_with_accessibility.accessibility_options).not_to be_empty
    end
  end

  describe "#find", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/teaching_events/find" } do
    let(:id) { "250930-get-into-teaching-north-event" }

    it "returns a single TeachingEvents::Resource instance" do
      event = resource.find(id)
      expect(event).to be_a(CRM::Resources::TeachingEvents::Resource)
      expect(event.id).to be_a(String)
      expect(event.name).to be_a(String)
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

    it "creates an event and returns a TeachingEvents::Resource" do
      event = resource.create(body)
      expect(event).to be_a(CRM::Resources::TeachingEvents::Resource)
      expect(event.id).to be_a(String)
      expect(event.name).to be_a(String)
    end
  end
end
