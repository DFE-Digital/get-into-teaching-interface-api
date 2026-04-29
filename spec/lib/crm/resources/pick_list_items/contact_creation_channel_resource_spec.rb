require "rails_helper"

RSpec.describe CRM::Resources::PickListItems::ContactCreationChannelResource do
  subject(:resource) { described_class.new }

  describe "#sources" do
    it "raises NotImplementedError" do
      expect { resource.sources }.to raise_error(NotImplementedError)
    end
  end

  describe "#services" do
    it "raises NotImplementedError" do
      expect { resource.services }.to raise_error(NotImplementedError)
    end
  end
end
