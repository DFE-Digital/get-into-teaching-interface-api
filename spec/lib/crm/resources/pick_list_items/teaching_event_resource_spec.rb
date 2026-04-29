require "rails_helper"

RSpec.describe CRM::Resources::PickListItems::TeachingEventResource do
  subject(:resource) { described_class.new }

  describe "#types" do
    it "raises NotImplementedError" do
      expect { resource.types }.to raise_error(NotImplementedError)
    end
  end
end
