require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::SchoolsExperienceResource do
  let(:client) { CRM::Adapters::GetIntoTeaching::Client.new(api_key: "test-api-key") }

  subject(:resource) { described_class.new(client) }

  describe "#create_candidate", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/schools_experience/create_candidate" } do
    let(:body) do
      {
        email: "johndoe@example.com",
        first_name: "John",
        last_name: "Doe",
        preferred_teaching_subject_id: "b02655a1-2afa-e811-a981-000d3a276620",
        accepted_policy_id: "4872c8ed-0229-f111-8342-7c1e5285e3ab",
        address_line1: "123 Main St",
        address_city: "London",
        address_state_or_province: "London",
        address_postcode: "SW1A 1AA",
        telephone: "01234567890",
        has_dbs_certificate: true,
      }
    end

    it "returns a CandidateResource with the candidate data" do
      candidate = resource.create_candidate(body)
      expect(candidate).to be_a(CRM::Resources::SchoolsExperience::CandidateResource)
      expect(candidate.candidate_id).to be_present
      expect(candidate.email).to eq("johndoe@example.com")
      expect(candidate.first_name).to eq("John")
      expect(candidate.last_name).to eq("Doe")
    end
  end

  describe "#create_school_experience", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/schools_experience/create_school_experience" } do
    let(:id) { "candidate-123" }
    let(:body) do
      {
        schoolUrn: "123456",
        durationOfPlacementInDays: 5,
        dateOfSchoolExperience: "2026-09-15",
        teachingSubjectId: "subject-1",
        notes: "Student showed great interest.",
        schoolName: "Example High School",
      }
    end

    it "returns a Faraday response with 204" do
      response = resource.create_school_experience(id, body)
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eq(204)
    end
  end

  describe "#exchange_access_token", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/schools_experience/exchange_access_token" } do
    let(:token) { "abc123" }
    let(:body) do
      {
        email: "johndoe@example.com",
        first_name: "John",
        last_name: "Doe",
      }
    end

    it "returns a CandidateResource with the candidate data" do
      candidate = resource.exchange_access_token(token, body)
      expect(candidate).to be_a(CRM::Resources::SchoolsExperience::CandidateResource)
      expect(candidate.candidate_id).to be_present
      expect(candidate.email).to be_present
    end
  end
end
