require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::CandidatesResource do
  subject(:resource) { described_class.new }

  describe "#create_access_token" do
    it "returns true" do
      expect(resource.create_access_token({})).to be(true)
    end
  end
end
