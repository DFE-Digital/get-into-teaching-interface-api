require "rails_helper"

RSpec.describe CRM::Client::Countries do
  describe "#all" do
    context "with the default adapter" do
      it "returns an array of CRM::Client::Country objects" do
        countries = described_class.new.all

        expect(countries).to all(be_a(CRM::Client::Country))
        expect(countries.length).to eq(5)
      end
    end

    context "with an injected adapter double" do
      let(:adapter) { instance_double(CRM::Adapters::Demo::Countries) }
      let(:countries_client) { described_class.new(adapter: adapter) }
      let(:stub_countries) { [ CRM::Client::Country.new(id: "1", value: "France", iso_code: "FR") ] }

      before { allow(adapter).to receive(:all).and_return(stub_countries) }

      it "delegates to the adapter" do
        expect(countries_client.all).to eq(stub_countries)
      end

      it "calls the adapter's all method exactly once" do
        countries_client.all

        expect(adapter).to have_received(:all).once
      end
    end
  end
end
