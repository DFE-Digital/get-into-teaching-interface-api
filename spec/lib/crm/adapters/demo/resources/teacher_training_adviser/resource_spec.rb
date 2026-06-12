require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::TeacherTrainingAdviser::Resource do
  subject(:resource) { described_class.new }

  describe "#create_candidate" do
    it "returns true" do
      expect(resource.create_candidate({})).to be(true)
    end
  end

  describe "#exchange_access_token" do
    let(:result) { resource.exchange_access_token("token", {}) }

    it "returns a Data object with a body" do
      expect(result).to respond_to(:body)
    end

    it "returns a hash from body" do
      expect(result.body).to be_a(Hash)
    end

    it "includes the candidateId and email" do
      expect(result.body).to include("candidateId", "email")
    end
  end

  describe "#matchback" do
    let(:result) { resource.matchback({}) }

    it "returns a Data object with a body" do
      expect(result).to respond_to(:body)
    end

    it "returns a hash from body" do
      expect(result.body).to be_a(Hash)
    end

    it "includes the candidateId" do
      expect(result.body).to include("candidateId")
    end
  end
end
