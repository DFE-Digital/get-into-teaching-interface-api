require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::SchoolsExperienceResource do
  subject(:resource) { described_class.new }

  describe "#create_school_experience" do
    let(:result) { resource.create_school_experience("candidate-123", {}) }

    it "returns a Data object with a body" do
      expect(result).to respond_to(:body)
    end

    it "returns a hash from body" do
      expect(result.body).to be_a(Hash)
    end
  end

  describe "#create_candidate" do
    let(:result) { resource.create_candidate({}) }

    it "returns a CandidateResource instance" do
      expect(result).to be_a(CRM::Resources::SchoolsExperience::CandidateResource)
    end

    it "includes all sign-up fields as members" do
      expect(result.to_h).to include(
        email: "johndoe@example.com",
        first_name: "John",
        last_name: "Doe",
        preferred_teaching_subject_id: "subject-1",
        address_line1: "123 Main St",
        address_city: "London",
        address_state_or_province: "London",
        address_postcode: "SW1A 1AA",
        telephone: "01234567890",
        has_dbs_certificate: true,
        accepted_policy_id: "policy-1",
        candidate_id: "abc-123",
      )
    end
  end
end
