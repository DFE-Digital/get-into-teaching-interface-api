require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::PickListItems::PastTeachingPositionResource do
  subject(:resource) { described_class.new }

  describe "#education_phases" do
    it "returns a Demo PickListItems::PastTeachingPosition::EducationPhasesResource" do
      expect(resource.education_phases).to be_a(CRM::Adapters::Demo::Resources::PickListItems::PastTeachingPosition::EducationPhasesResource)
    end
  end
end
