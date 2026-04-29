require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::PickListItems::TeachingEventResource do
  subject(:resource) { described_class.new }

  describe "#types" do
    it "returns a Demo PickListItems::TeachingEvent::TypesResource" do
      expect(resource.types).to be_a(CRM::Adapters::Demo::Resources::PickListItems::TeachingEvent::TypesResource)
    end
  end

  describe "#regions" do
    it "returns a Demo PickListItems::TeachingEvent::RegionsResource" do
      expect(resource.regions).to be_a(CRM::Adapters::Demo::Resources::PickListItems::TeachingEvent::RegionsResource)
    end
  end

  describe "#statuses" do
    it "returns a Demo PickListItems::TeachingEvent::StatusesResource" do
      expect(resource.statuses).to be_a(CRM::Adapters::Demo::Resources::PickListItems::TeachingEvent::StatusesResource)
    end
  end

  describe "#registration_channels" do
    it "returns a Demo PickListItems::TeachingEvent::RegistrationChannelsResource" do
      expect(resource.registration_channels).to be_a(CRM::Adapters::Demo::Resources::PickListItems::TeachingEvent::RegistrationChannelsResource)
    end
  end

  describe "#accessibility_items" do
    it "returns a Demo PickListItems::TeachingEvent::AccessibilityItemsResource" do
      expect(resource.accessibility_items).to be_a(CRM::Adapters::Demo::Resources::PickListItems::TeachingEvent::AccessibilityItemsResource)
    end
  end
end
