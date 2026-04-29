require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::PickListItems::CandidateResource do
  let(:client) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }

  subject(:resource) { described_class.new(client) }

  describe "#initial_teacher_training_years" do
    it "returns a GIT PickListItems::Candidate::InitialTeacherTrainingYearsResource" do
      expect(resource.initial_teacher_training_years).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::Candidate::InitialTeacherTrainingYearsResource)
    end
  end

  describe "#preferred_education_phases" do
    it "returns a GIT PickListItems::Candidate::PreferredEducationPhasesResource" do
      expect(resource.preferred_education_phases).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::Candidate::PreferredEducationPhasesResource)
    end
  end

  describe "#channels" do
    it "returns a GIT PickListItems::Candidate::ChannelsResource" do
      expect(resource.channels).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::Candidate::ChannelsResource)
    end
  end
end
