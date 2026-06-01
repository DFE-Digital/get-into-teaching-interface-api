require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::GetIntoTeaching::CallbacksResource do
  subject(:resource) { described_class.new }

  describe "#create" do
    it "returns a CallbackResource instance" do
      expect(resource.create).to be_a(CRM::Resources::GetIntoTeaching::CallbackResource)
    end

    it "returns an entry with id and value readers" do
      expect(resource.create).to respond_to(:id, :value)
    end
  end
end
