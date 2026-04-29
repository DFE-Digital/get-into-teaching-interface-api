require "rails_helper"

RSpec.describe CRM::Resources::PickListItems::TeachingEvent::RegistrationChannelsResource do
  subject(:resource) { described_class.new }

  describe "#all" do
    it "raises NotImplementedError" do
      expect { resource.all }.to raise_error(NotImplementedError)
    end
  end
end
