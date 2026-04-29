require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::PickListItemsResource do
  subject(:resource) { described_class.new }

  describe "#candidate" do
    it "returns a Demo PickListItems::CandidateResource" do
      expect(resource.candidate).to be_a(CRM::Adapters::Demo::Resources::PickListItems::CandidateResource)
    end
  end

  describe "#qualification" do
    it "returns a Demo PickListItems::QualificationResource" do
      expect(resource.qualification).to be_a(CRM::Adapters::Demo::Resources::PickListItems::QualificationResource)
    end
  end

  describe "#past_teaching_position" do
    it "returns a Demo PickListItems::PastTeachingPositionResource" do
      expect(resource.past_teaching_position).to be_a(CRM::Adapters::Demo::Resources::PickListItems::PastTeachingPositionResource)
    end
  end

  describe "#teaching_event" do
    it "returns a Demo PickListItems::TeachingEventResource" do
      expect(resource.teaching_event).to be_a(CRM::Adapters::Demo::Resources::PickListItems::TeachingEventResource)
    end
  end

  describe "#phone_call" do
    it "returns a Demo PickListItems::PhoneCallResource" do
      expect(resource.phone_call).to be_a(CRM::Adapters::Demo::Resources::PickListItems::PhoneCallResource)
    end
  end

  describe "#service_subscription" do
    it "returns a Demo PickListItems::ServiceSubscriptionResource" do
      expect(resource.service_subscription).to be_a(CRM::Adapters::Demo::Resources::PickListItems::ServiceSubscriptionResource)
    end
  end

  describe "#contact_creation_channel" do
    it "returns a Demo PickListItems::ContactCreationChannelResource" do
      expect(resource.contact_creation_channel).to be_a(CRM::Adapters::Demo::Resources::PickListItems::ContactCreationChannelResource)
    end
  end
end
