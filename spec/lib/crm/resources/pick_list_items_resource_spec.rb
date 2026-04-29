require "rails_helper"

RSpec.describe CRM::Resources::PickListItemsResource do
  subject(:resource) { described_class.new }

  describe "#candidate" do
    it "raises NotImplementedError" do
      expect { resource.candidate }.to raise_error(NotImplementedError)
    end
  end

  describe "#qualification" do
    it "raises NotImplementedError" do
      expect { resource.qualification }.to raise_error(NotImplementedError)
    end
  end

  describe "#past_teaching_position" do
    it "raises NotImplementedError" do
      expect { resource.past_teaching_position }.to raise_error(NotImplementedError)
    end
  end

  describe "#teaching_event" do
    it "raises NotImplementedError" do
      expect { resource.teaching_event }.to raise_error(NotImplementedError)
    end
  end
end
