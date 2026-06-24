require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::GetIntoTeachingResource do
  subject(:resource) { described_class.new }

  describe "#create_callback" do
    let(:result) { resource.create_callback({}) }

    it "returns true" do
      expect(result).to be(true)
    end
  end

  describe "#exchange_access_token" do
    let(:result) { resource.exchange_access_token("token", {}) }

    it "returns a CandidateResource" do
      expect(result).to be_a(CRM::Resources::GetIntoTeaching::CandidateResource)
    end

    it "includes the candidate_id and email" do
      expect(result.candidate_id).to be_present
      expect(result.email).to be_present
    end
  end

  describe "#matchback" do
    let(:result) { resource.matchback({}) }

    it "returns a CandidateResource" do
      expect(result).to be_a(CRM::Resources::GetIntoTeaching::CandidateResource)
    end

    it "includes the candidate_id" do
      expect(result.candidate_id).to be_present
    end
  end
end
