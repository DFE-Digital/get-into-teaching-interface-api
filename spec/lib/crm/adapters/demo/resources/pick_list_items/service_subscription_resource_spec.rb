require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::PickListItems::ServiceSubscriptionResource do
  subject(:resource) { described_class.new }

  describe "#types" do
    it "returns a Demo PickListItems::ServiceSubscription::TypesResource" do
      expect(resource.types).to be_a(CRM::Adapters::Demo::Resources::PickListItems::ServiceSubscription::TypesResource)
    end
  end
end
