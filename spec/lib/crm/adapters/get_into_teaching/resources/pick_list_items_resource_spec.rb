require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::PickListItemsResource do
  let(:client) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }

  subject(:resource) { described_class.new(client) }

  describe "#candidate" do
    it "returns a GIT PickListItems::CandidateResource" do
      expect(resource.candidate).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::CandidateResource)
    end
  end

  describe "#qualification" do
    it "returns a GIT PickListItems::QualificationResource" do
      expect(resource.qualification).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::QualificationResource)
    end
  end

  describe "#past_teaching_position" do
    it "returns a GIT PickListItems::PastTeachingPositionResource" do
      expect(resource.past_teaching_position).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::PastTeachingPositionResource)
    end
  end

  describe "#teaching_event" do
    it "returns a GIT PickListItems::TeachingEventResource" do
      expect(resource.teaching_event).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::TeachingEventResource)
    end
  end

  describe "#phone_call" do
    it "returns a GIT PickListItems::PhoneCallResource" do
      expect(resource.phone_call).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::PhoneCallResource)
    end
  end

  describe "#service_subscription" do
    it "returns a GIT PickListItems::ServiceSubscriptionResource" do
      expect(resource.service_subscription).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::ServiceSubscriptionResource)
    end
  end

  describe "#contact_creation_channel" do
    it "returns a GIT PickListItems::ContactCreationChannelResource" do
      expect(resource.contact_creation_channel).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::ContactCreationChannelResource)
    end
  end
end
