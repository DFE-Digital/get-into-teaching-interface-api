require "rails_helper"

RSpec.describe CRM::Resources::TeacherTrainingAdviser::CandidatesResource do
  subject(:resource) { described_class.new }

  describe "#create" do
    it "raises NotImplementedError" do
      expect { resource.create }.to raise_error(NotImplementedError)
    end
  end
end
