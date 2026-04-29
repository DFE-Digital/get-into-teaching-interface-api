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
end
