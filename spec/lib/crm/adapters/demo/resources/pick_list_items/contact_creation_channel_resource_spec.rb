require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::PickListItems::ContactCreationChannelResource do
  subject(:resource) { described_class.new }

  describe "#sources" do
    it "returns a Demo PickListItems::ContactCreationChannel::SourcesResource" do
      expect(resource.sources).to be_a(CRM::Adapters::Demo::Resources::PickListItems::ContactCreationChannel::SourcesResource)
    end
  end

  describe "#services" do
    it "returns a Demo PickListItems::ContactCreationChannel::ServicesResource" do
      expect(resource.services).to be_a(CRM::Adapters::Demo::Resources::PickListItems::ContactCreationChannel::ServicesResource)
    end
  end
end
