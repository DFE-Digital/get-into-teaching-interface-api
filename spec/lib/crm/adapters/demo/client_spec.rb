require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Client do
  subject(:client) { described_class.new }

  describe "#lookup_items" do
    it "returns a Demo LookUpItemsResource" do
      expect(client.lookup_items).to be_a(CRM::Adapters::Demo::Resources::LookUpItemsResource)
    end
  end
end
