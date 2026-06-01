require "rails_helper"

RSpec.describe CRM::Resources::GetIntoTeachingResource do
  subject(:resource) { described_class.new }

  describe "#callbacks" do
    it "raises NotImplementedError" do
      expect { resource.callbacks }.to raise_error(NotImplementedError)
    end
  end
end
