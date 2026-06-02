require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::TeacherTrainingAdviserResource do
  let(:client) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }

  subject(:resource) { described_class.new(client) }

  describe "#candidates" do
    it "returns a GIT TeacherTrainingAdviser::CandidatesResource" do
      expect(resource.candidates).to be_a(CRM::Adapters::GetIntoTeaching::Resources::TeacherTrainingAdviser::CandidatesResource)
    end
  end
end
