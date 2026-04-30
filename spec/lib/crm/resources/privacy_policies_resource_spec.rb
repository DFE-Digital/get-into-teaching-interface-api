require "rails_helper"

RSpec.describe CRM::Resources::PrivacyPoliciesResource do
  subject(:resource) { described_class.new }

  describe "#find" do
    it "raises NotImplementedError" do
      expect { resource.find }.to raise_error(NotImplementedError)
    end
  end
end
