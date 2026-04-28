# frozen_string_literal: true

require "rails_helper"

RSpec.describe CRM::Client do
  describe "#lookup_items" do
    context "with the default adapter" do
      it "returns a Demo LookUpItemsResource" do
        expect(described_class.new.lookup_items).to be_a(CRM::Adapters::Demo::Resources::LookUpItemsResource)
      end
    end

    context "with an injected adapter" do
      let(:adapter) { instance_double(CRM::Adapters::Demo::Client) }
      let(:lookup_items_resource) { instance_double(CRM::Adapters::Demo::Resources::LookUpItemsResource) }

      before { allow(adapter).to receive(:lookup_items).and_return(lookup_items_resource) }

      it "delegates to the injected adapter" do
        result = described_class.new(adapter: adapter).lookup_items

        expect(result).to eq(lookup_items_resource)
      end
    end
  end
end
