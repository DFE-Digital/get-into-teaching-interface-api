require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::PickListItems::CandidateResource do
  subject(:resource) { described_class.new }

  describe "#initial_teacher_training_years" do
    it "returns a Demo PickListItems::Candidate::InitialTeacherTrainingYearsResource" do
      expect(resource.initial_teacher_training_years).to be_a(CRM::Adapters::Demo::Resources::PickListItems::Candidate::InitialTeacherTrainingYearsResource)
    end
  end
end
