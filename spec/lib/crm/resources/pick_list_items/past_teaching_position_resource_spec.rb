require "rails_helper"

RSpec.describe CRM::Resources::PickListItems::PastTeachingPositionResource do
  subject(:resource) { described_class.new }

  describe "#education_phases" do
    it "raises NotImplementedError" do
      expect { resource.education_phases }.to raise_error(NotImplementedError)
    end
  end
end
