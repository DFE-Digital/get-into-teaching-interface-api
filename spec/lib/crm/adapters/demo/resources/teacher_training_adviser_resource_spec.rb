require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::TeacherTrainingAdviserResource do
  subject(:resource) { described_class.new }

  describe "#candidates" do
    it "returns a Demo TeacherTrainingAdviser::CandidatesResource" do
      expect(resource.candidates).to be_a(CRM::Adapters::Demo::Resources::TeacherTrainingAdviser::CandidatesResource)
    end
  end
end
