require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::PickListItems::QualificationResource do
  subject(:resource) { described_class.new }

  describe "#degree_statuses" do
    it "returns a Demo PickListItems::Qualification::DegreeStatusesResource" do
      expect(resource.degree_statuses).to be_a(CRM::Adapters::Demo::Resources::PickListItems::Qualification::DegreeStatusesResource)
    end
  end

  describe "#types" do
    it "returns a Demo PickListItems::Qualification::TypesResource" do
      expect(resource.types).to be_a(CRM::Adapters::Demo::Resources::PickListItems::Qualification::TypesResource)
    end
  end
end
