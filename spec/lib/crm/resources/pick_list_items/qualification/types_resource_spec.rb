require "rails_helper"

RSpec.describe CRM::Resources::PickListItems::Qualification::TypesResource do
  subject(:resource) { described_class.new }

  describe "#all" do
    it "raises NotImplementedError" do
      expect { resource.all }.to raise_error(NotImplementedError)
    end
  end
end
