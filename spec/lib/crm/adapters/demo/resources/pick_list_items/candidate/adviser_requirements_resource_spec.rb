require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::PickListItems::Candidate::AdviserRequirementsResource do
  subject(:resource) { described_class.new }

  describe "#all" do
    it "returns an array" do
      expect(resource.all).to be_an(Array)
    end

    it "returns AdviserRequirementResource instances" do
      expect(resource.all).to all(be_a(CRM::Resources::PickListItems::Candidate::AdviserRequirementResource))
    end

    it "returns entries with id and value readers" do
      item = resource.all.first

      expect(item).to respond_to(:id, :value)
    end
  end
end
