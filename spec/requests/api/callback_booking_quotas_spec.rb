require "rails_helper"

RSpec.describe "GET /api/callback_booking_quotas", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  before do
    quotas = double
    allow(quotas).to receive(:all).and_return([ {
      "id" => "1", "time_slot" => "09:00", "day" => "Monday",
      "start_at" => "2026-01-01T09:00:00Z", "end_at" => "2026-01-01T17:00:00Z",
      "number_of_bookings" => 0, "quota" => 10, "is_available" => true
    } ])
    client = instance_double(CRM::Client)
    allow(client).to receive(:callback_booking_quotas).and_return(quotas)
    allow(CRM::Client).to receive(:new).and_return(client)
  end

  describe "response format" do
    it "returns JSON" do
      get(api_callback_booking_quotas_path, headers:)
      expect(response.content_type).to match(%r{application/json})
    end

    it "returns JSON even when the client requests HTML" do
      get api_callback_booking_quotas_path, headers: headers.merge({ "Accept" => "text/html" })

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns a data envelope containing an array" do
      get(api_callback_booking_quotas_path, headers:)
      body = response.parsed_body
      expect(body).to be_an(Array)
    end

    it "returns items with id and value fields" do
      get(api_callback_booking_quotas_path, headers:)
      item = response.parsed_body.first
      expect(item).to include(
      "id",
      "time_slot",
      "day",
      "start_at",
      "end_at",
      "number_of_bookings",
      "quota",
      "is_available",
      )
    end
  end
end
