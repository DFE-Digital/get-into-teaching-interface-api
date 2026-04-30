require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::PrivacyPoliciesResource do
  subject(:resource) { described_class.new }

  describe "#find" do
    it "returns PrivacyPolicyResource instance" do
      expect(resource.find('some-id')).to be_a(CRM::Resources::PrivacyPolicyResource)
    end

    it "returns entry with id, text and created_at readers" do
      item = resource.find('some-id')

      expect(item).to respond_to(:id, :text, :created_at)
    end
  end
end
