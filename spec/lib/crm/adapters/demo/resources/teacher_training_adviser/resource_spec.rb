require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::TeacherTrainingAdviser::Resource do
  subject(:resource) { described_class.new }

  describe "#create_candidate" do
    let(:result) { resource.create_candidate({}) }

    it "returns a DegreeResource" do
      expect(result).to be_a(CRM::Resources::TeacherTrainingAdviser::DegreeResource)
    end

    it "includes degree_status_id" do
      expect(result.degree_status_id).to eq(222750000)
    end
  end

  describe "#exchange_access_token" do
    let(:result) { resource.exchange_access_token("token", {}) }

    it "returns a CandidateResource" do
      expect(result).to be_a(CRM::Resources::TeacherTrainingAdviser::CandidateResource)
    end

    it "includes the candidate_id and email" do
      expect(result.candidate_id).to be_present
      expect(result.email).to be_present
    end
  end

  describe "#matchback" do
    let(:result) { resource.matchback({}) }

    it "returns a CandidateResource" do
      expect(result).to be_a(CRM::Resources::TeacherTrainingAdviser::CandidateResource)
    end

    it "includes the candidate_id" do
      expect(result.candidate_id).to be_present
    end
  end
end
