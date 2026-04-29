require "rails_helper"

RSpec.describe CRM::Resources::PickListItemsResource do
  subject(:resource) { described_class.new }

  describe "#candidate" do
    it "raises NotImplementedError" do
      expect { resource.candidate }.to raise_error(NotImplementedError)
    end
  end
end
