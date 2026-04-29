require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::PickListItems::ServiceSubscriptionResource do
  let(:client) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }

  subject(:resource) { described_class.new(client) }

  describe "#types" do
    it "returns a GIT PickListItems::ServiceSubscription::TypesResource" do
      expect(resource.types).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::ServiceSubscription::TypesResource)
    end
  end
end
