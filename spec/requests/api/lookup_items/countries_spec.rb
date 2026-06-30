require "rails_helper"

RSpec.describe "GET /api/lookup_items/countries", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  before do
    countries_resource = double
    allow(countries_resource).to receive(:all)
      .and_return([ { "id" => "1", "value" => "United Kingdom", "iso_code" => "GB" } ])

    lookup_items = double
    allow(lookup_items).to receive(:countries).and_return(countries_resource)

    crm_client = double
    allow(crm_client).to receive(:lookup_items).and_return(lookup_items)
    allow(CRM::Client).to receive(:new).and_return(crm_client)
  end

  describe "response format" do
    it "returns JSON" do
      get(api_lookup_items_countries_path, headers:)
      expect(response.content_type).to match(%r{application/json})
    end

    it "returns JSON even when the client requests HTML" do
      get api_lookup_items_countries_path, headers: headers.merge({ "Accept" => "text/html" })

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns a data envelope containing an array of countries" do
      get(api_lookup_items_countries_path, headers:)
      body = response.parsed_body
      expect(body).to be_an(Array)
    end

    it "returns countries with id, value, and iso_code fields" do
      get(api_lookup_items_countries_path, headers:)
      country = response.parsed_body.first
      expect(country).to include("id", "value", "iso_code")
    end
  end
end
