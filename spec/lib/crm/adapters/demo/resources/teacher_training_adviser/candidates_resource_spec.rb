require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::TeacherTrainingAdviser::CandidatesResource do
  subject(:resource) { described_class.new }

  describe "#create" do
    it "returns a CandidateResource instance" do
      expect(resource.create).to be_a(CRM::Resources::TeacherTrainingAdviser::CandidateResource)
    end

    it "returns an entry with id and value readers" do
      expect(resource.create).to respond_to(:id, :value)
    end
  end
end
