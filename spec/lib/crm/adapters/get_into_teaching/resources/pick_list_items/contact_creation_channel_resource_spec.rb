require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::PickListItems::ContactCreationChannelResource do
  let(:client) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }

  subject(:resource) { described_class.new(client) }

  describe "#sources" do
    it "returns a GIT PickListItems::ContactCreationChannel::SourcesResource" do
      expect(resource.sources).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::ContactCreationChannel::SourcesResource)
    end
  end

  describe "#services" do
    it "returns a GIT PickListItems::ContactCreationChannel::ServicesResource" do
      expect(resource.services).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::ContactCreationChannel::ServicesResource)
    end
  end
end
