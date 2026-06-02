require "rails_helper"

RSpec.describe CRM::Resources::TeacherTrainingAdviserResource do
  subject(:resource) { described_class.new }

  describe "#candidates" do
    it "raises NotImplementedError" do
      expect { resource.candidates }.to raise_error(NotImplementedError)
    end
  end
end
