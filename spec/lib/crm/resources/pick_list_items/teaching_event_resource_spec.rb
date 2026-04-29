require "rails_helper"

RSpec.describe CRM::Resources::PickListItems::TeachingEventResource do
  subject(:resource) { described_class.new }

  describe "#types" do
    it "raises NotImplementedError" do
      expect { resource.types }.to raise_error(NotImplementedError)
    end
  end

  describe "#regions" do
    it "raises NotImplementedError" do
      expect { resource.regions }.to raise_error(NotImplementedError)
    end
  end

  describe "#statuses" do
    it "raises NotImplementedError" do
      expect { resource.statuses }.to raise_error(NotImplementedError)
    end
  end
end
