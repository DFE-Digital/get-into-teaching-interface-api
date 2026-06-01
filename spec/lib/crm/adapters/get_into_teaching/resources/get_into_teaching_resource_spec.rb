require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::GetIntoTeachingResource do
  let(:client) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }

  subject(:resource) { described_class.new(client) }

  describe "#callbacks" do
    it "returns a GIT GetIntoTeaching::CallbacksResource" do
      expect(resource.callbacks).to be_a(CRM::Adapters::GetIntoTeaching::Resources::GetIntoTeaching::CallbacksResource)
    end
  end
end
