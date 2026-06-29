require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::CallbackBookingQuotasResource do
  let(:base_url) { "https://test.example.com" }
  let(:client) { CRM::Adapters::GetIntoTeaching::Client.new(base_url: base_url, api_key: "test-key") }

  subject(:resource) { described_class.new(client) }

  describe "#all" do
    before do
      stub_request(:get, "#{base_url}/api/callback_booking_quotas")
        .to_return(
          status: 200,
          body: [
            {
              "timeSlot": "5pm - 5:30pm",
              "day": "Wednesday 29 April",
              "startAt": "2026-04-29T16:00:00Z",
              "endAt": "2026-04-29T16:30:00Z",
              "numberOfBookings": 0,
              "quota": 20,
              "isAvailable": true,
              "id": "411558c7-7fa3-f011-bbd3-000d3a44b0fa",
            },
            {
              "timeSlot": "9am - 9:30am",
              "day": "Thursday 30 April",
              "startAt": "2026-04-30T08:00:00Z",
              "endAt": "2026-04-30T08:30:00Z",
              "numberOfBookings": 0,
              "quota": 20,
              "isAvailable": true,
              "id": "73bdc2c6-7fa3-f011-bbd3-6045bd9399eb",
            },
          ].to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "returns CallbackBookingQuotaResource instances" do
      expect(resource.all).to all(be_a(CRM::Resources::CallbackBookingQuotaResource))
    end

    it "maps API response attributes to snake_case" do
      item = resource.all.first

      expect(item.id).to eq("411558c7-7fa3-f011-bbd3-000d3a44b0fa")
      expect(item.time_slot).to eq("5pm - 5:30pm")
      expect(item.day).to eq("Wednesday 29 April")
      expect(item.start_at).to eq("2026-04-29T16:00:00Z")
      expect(item.end_at).to eq("2026-04-29T16:30:00Z")
      expect(item.number_of_bookings).to eq(0)
      expect(item.quota).to eq(20)
      expect(item.is_available).to eq(true)
    end

    context "when the API returns an error" do
      before do
        stub_request(:get, "#{base_url}/api/callback_booking_quotas")
          .to_return(status: 401, body: { "error" => "Unauthorized" }.to_json,
                     headers: { "Content-Type" => "application/json" })
      end

      it "raises UnauthorizedError" do
        expect { resource.all }
          .to raise_error(CRM::Adapters::GetIntoTeaching::Resource::UnauthorizedError, /valid authentication credentials/)
      end
    end
  end
end
