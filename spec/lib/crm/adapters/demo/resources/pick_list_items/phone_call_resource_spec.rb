require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::PickListItems::PhoneCallResource do
  subject(:resource) { described_class.new }

  describe "#channels" do
    it "returns a Demo PickListItems::PhoneCall::ChannelsResource" do
      expect(resource.channels).to be_a(CRM::Adapters::Demo::Resources::PickListItems::PhoneCall::ChannelsResource)
    end
  end
end
