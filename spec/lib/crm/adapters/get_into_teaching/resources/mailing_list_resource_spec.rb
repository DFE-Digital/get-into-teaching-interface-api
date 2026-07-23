require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::MailingListResource do
  let(:client) { CRM::Adapters::GetIntoTeaching::Client.new(api_key: "test-api-key") }
  subject(:resource) { described_class.new(client) }

  describe "#create_member", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/mailing_list/members" } do
    let(:body) do
      {
        email: "johndoe@example.com",
        firstName: "John",
        lastName: "Doe",
        acceptedPolicyId: "4872c8ed-0229-f111-8342-7c1e5285e3ab",
        considerationJourneyStageId: 222750000,
        preferredTeachingSubjectId: "b02655a1-2afa-e811-a981-000d3a276620",
        addressPostcode: "BN1 1AA",
        graduationYear: 2028,
        degreeStatusId: 222750000,
        candidateId: "d85a2f0b-290f-4931-98e2-e7d817ac38f3",
      }
    end

    it "returns a DegreeResource" do
      result = resource.create_member(body)
      expect(result).to be_a(CRM::Resources::TeacherTrainingAdviser::DegreeResource)
      expect(result.degree_status_id).to eq(222750003)
    end
  end

  describe "#exchange_access_token", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/mailing_list/exchange_access_token" } do
    let(:token) { "abc123" }
    let(:body) do
      {
        email: "johndoe@example.com",
        firstName: "John",
        lastName: "Doe",
        dateOfBirth: "1990-01-01",
      }
    end

    it "returns a CandidateResource" do
      result = resource.exchange_access_token(token, body)
      expect(result).to be_a(CRM::Resources::MailingList::CandidateResource)
      expect(result.candidate_id).to be_present
    end
  end
end
