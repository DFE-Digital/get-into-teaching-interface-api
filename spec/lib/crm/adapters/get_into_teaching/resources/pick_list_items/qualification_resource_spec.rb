require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::PickListItems::QualificationResource do
  let(:client) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }

  subject(:resource) { described_class.new(client) }

  describe "#degree_statuses" do
    it "returns a GIT PickListItems::Qualification::DegreeStatusesResource" do
      expect(resource.degree_statuses).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::Qualification::DegreeStatusesResource)
    end
  end

  describe "#types" do
    it "returns a GIT PickListItems::Qualification::TypesResource" do
      expect(resource.types).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::Qualification::TypesResource)
    end
  end
end
