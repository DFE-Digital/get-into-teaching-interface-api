require "rails_helper"

RSpec.describe "GET /api/lookup_items/degree_countries", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  before do
    degree_countries_resource = double
    allow(degree_countries_resource).to receive(:all)
      .and_return([ { "id" => "1", "value" => "United Kingdom", "iso_code" => "GB" } ])

    lookup_items = double
    allow(lookup_items).to receive(:degree_countries).and_return(degree_countries_resource)

    crm_client = double
    allow(crm_client).to receive(:lookup_items).and_return(lookup_items)
    allow(CRM::Client).to receive(:new).and_return(crm_client)
  end

  describe "response format" do
    it "returns JSON" do
      get(api_lookup_items_degree_countries_path, headers:)
      expect(response.content_type).to match(%r{application/json})
    end

    it "returns JSON even when the client requests HTML" do
      get api_lookup_items_degree_countries_path, headers: headers.merge({ "Accept" => "text/html" })

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns a data envelope containing an array of degree countries" do
      get(api_lookup_items_degree_countries_path, headers:)
      body = response.parsed_body
      expect(body).to be_an(Array)
    end

    it "returns degree countries with id, value, and iso_code fields" do
      get(api_lookup_items_degree_countries_path, headers:)
      degree_country = response.parsed_body.first
      expect(degree_country).to include("id", "value", "iso_code")
    end
  end
end
