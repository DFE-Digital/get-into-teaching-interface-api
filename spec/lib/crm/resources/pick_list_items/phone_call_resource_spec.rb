require "rails_helper"

RSpec.describe CRM::Resources::PickListItems::PhoneCallResource do
  subject(:resource) { described_class.new }

  describe "#channels" do
    it "raises NotImplementedError" do
      expect { resource.channels }.to raise_error(NotImplementedError)
    end
  end
end
