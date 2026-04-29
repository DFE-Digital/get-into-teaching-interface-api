require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::PickListItems::TeachingEventResource do
  let(:client) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }

  subject(:resource) { described_class.new(client) }

  describe "#types" do
    it "returns a GIT PickListItems::TeachingEvent::TypesResource" do
      expect(resource.types).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::TeachingEvent::TypesResource)
    end
  end

  describe "#regions" do
    it "returns a GIT PickListItems::TeachingEvent::RegionsResource" do
      expect(resource.regions).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::TeachingEvent::RegionsResource)
    end
  end
end
