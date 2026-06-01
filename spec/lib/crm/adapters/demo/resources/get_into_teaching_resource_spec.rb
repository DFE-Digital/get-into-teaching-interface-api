require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::GetIntoTeachingResource do
  subject(:resource) { described_class.new }

  describe "#callbacks" do
    it "returns a Demo GetIntoTeaching::CallbacksResource" do
      expect(resource.callbacks).to be_a(CRM::Adapters::Demo::Resources::GetIntoTeaching::CallbacksResource)
    end
  end
end
