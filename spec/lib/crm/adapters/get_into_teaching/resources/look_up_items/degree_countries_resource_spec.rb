# frozen_string_literal: true

require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::LookUpItems::DegreeCountriesResource do
  let(:base_url) { "https://test.example.com" }
  let(:client) { CRM::Adapters::GetIntoTeaching::Client.new(base_url: base_url, api_key: "test-key") }

  subject(:resource) { described_class.new(client) }

  describe "#all" do
    before do
      stub_request(:get, "#{base_url}/api/lookup_items/degree_countries")
        .to_return(
          status: 200,
          body: [
            { "id" => "abc-123", "value" => "United Kingdom", "isoCode" => "GB" },
            { "id" => "def-456", "value" => "France", "isoCode" => "FR" },
          ].to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "returns CRM::Resources::LookUpItems::CountryResource instances" do
      expect(resource.all).to all(be_a(CRM::Resources::LookUpItems::DegreeCountryResource))
    end

    it "maps API response attributes to snake_case" do
      country = resource.all.first

      expect(country.id).to eq("abc-123")
      expect(country.value).to eq("United Kingdom")
      expect(country.iso_code).to eq("GB")
    end

    context "when the API returns an error" do
      before do
        stub_request(:get, "#{base_url}/api/lookup_items/degree_countries")
          .to_return(status: 401, body: { "error" => "Unauthorized" }.to_json,
                     headers: { "Content-Type" => "application/json" })
      end

      it "raises Resource::Error" do
        expect { resource.all }
          .to raise_error(CRM::Adapters::GetIntoTeaching::Resource::Error, /valid authentication credentials/)
      end
    end
  end
end
