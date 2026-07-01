require "rails_helper"

RSpec.describe "GET /api/teaching_event_buildings", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  before do
    buildings = double
    allow(buildings).to receive(:all).and_return([ {
      "id" => "1", "venue" => "Main Hall", "address_line1" => "123 High St",
      "address_line2" => nil, "address_line3" => nil, "address_city" => "London",
      "address_postcode" => "SW1A 1AA", "image_url" => nil
    } ])
    client = instance_double(CRM::Client)
    allow(client).to receive(:teaching_event_buildings).and_return(buildings)
    allow(CRM::Client).to receive(:new).and_return(client)
  end

  describe "response format" do
    it "returns JSON" do
      get(api_teaching_event_buildings_path, headers:)
      expect(response.content_type).to match(%r{application/json})
    end

    it "returns JSON even when the client requests HTML" do
      get api_teaching_event_buildings_path, headers: headers.merge({ "Accept" => "text/html" })

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns a data envelope containing an array" do
      get(api_teaching_event_buildings_path, headers:)
      body = response.parsed_body
      expect(body).to be_an(Array)
    end

    it "returns items with id and value fields" do
      get(api_teaching_event_buildings_path, headers:)
      item = response.parsed_body.first
      expect(item).to include(
                        "venue",
                        "address_line1",
                        "address_line2",
                        "address_line3",
                        "address_city",
                        "address_postcode",
                        "image_url",
                        "id",
                      )
    end
  end
end
