require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::PickListItems::PastTeachingPositionResource do
  let(:client) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }

  subject(:resource) { described_class.new(client) }

  describe "#education_phases" do
    it "returns a GIT PickListItems::PastTeachingPosition::EducationPhasesResource" do
      expect(resource.education_phases).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::PastTeachingPosition::EducationPhasesResource)
    end
  end
end
