# frozen_string_literal: true

require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::LookUpItems::DegreeCountriesResource do
  subject(:resource) { described_class.new }

  describe "#all" do
    it "returns an array of 5 countries" do
      expect(resource.all.length).to eq(5)
    end

    it "returns CRM::Resources::LookUpItems::DegreeCountryResource instances" do
      expect(resource.all).to all(be_a(CRM::Resources::LookUpItems::DegreeCountryResource))
    end

    it "includes the expected ISO codes" do
      iso_codes = resource.all.map(&:iso_code)

      expect(iso_codes).to contain_exactly("US", "CA", "GB", "AU", "DE")
    end

    it "returns entries with id, value, and iso_code readers" do
      country = resource.all.first

      expect(country).to respond_to(:id, :value, :iso_code)
    end
  end
end
