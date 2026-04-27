require "rails_helper"

RSpec.describe "GET /api/lookup_items/countries", type: :request do
  before { Rails.cache.clear }

  describe "response format" do
    it "returns JSON" do
      get api_lookup_items_countries_path

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns JSON even when the client requests HTML" do
      get api_lookup_items_countries_path, headers: { "Accept" => "text/html" }

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns a data envelope containing an array of countries" do
      get api_lookup_items_countries_path

      body = response.parsed_body
      expect(body).to have_key("data")
      expect(body["data"]).to be_an(Array)
    end

    it "returns countries with id, value, and iso_code fields" do
      get api_lookup_items_countries_path

      country = response.parsed_body["data"].first
      expect(country).to include("id", "value", "iso_code")
    end
  end
end
