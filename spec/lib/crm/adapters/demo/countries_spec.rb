require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Countries do
  subject(:adapter) { described_class.new }

  describe "#all" do
    it "returns an array of 5 countries" do
      expect(adapter.all.length).to eq(5)
    end

    it "returns CRM::Client::Country instances" do
      expect(adapter.all).to all(be_a(CRM::Client::Country))
    end

    it "includes the expected ISO codes" do
      iso_codes = adapter.all.map(&:iso_code)

      expect(iso_codes).to contain_exactly("US", "CA", "GB", "AU", "DE")
    end

    it "returns entries with id, value, and iso_code readers" do
      country = adapter.all.first

      expect(country).to respond_to(:id, :value, :iso_code)
    end
  end
end
