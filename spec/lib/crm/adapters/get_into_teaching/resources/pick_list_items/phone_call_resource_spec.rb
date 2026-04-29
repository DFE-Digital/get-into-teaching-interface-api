require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::PickListItems::PhoneCallResource do
  let(:client) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }

  subject(:resource) { described_class.new(client) }

  describe "#channels" do
    it "returns a GIT PickListItems::PhoneCall::ChannelsResource" do
      expect(resource.channels).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::PhoneCall::ChannelsResource)
    end
  end
end
