require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::PickListItems::Candidate::GcseStatusesResource do
  subject(:resource) { described_class.new }

  describe "#all" do
    it "returns an array" do
      expect(resource.all).to be_an(Array)
    end

    it "returns GcseStatusResource instances" do
      expect(resource.all).to all(be_a(CRM::Resources::PickListItems::Candidate::GcseStatusResource))
    end

    it "returns entries with id and value readers" do
      item = resource.all.first

      expect(item).to respond_to(:id, :value)
    end
  end
end
