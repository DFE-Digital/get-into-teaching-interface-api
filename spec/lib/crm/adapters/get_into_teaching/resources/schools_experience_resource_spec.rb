require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::SchoolsExperienceResource do
  let(:client) { CRM::Adapters::GetIntoTeaching::Client.new }

  subject(:resource) { described_class.new(client) }

  describe "#create_candidate", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/schools_experience/create_candidate" } do
    let(:body) do
      {
        email: "johndoe@example.com",
        first_name: "John",
        last_name: "Doe",
        preferred_teaching_subject_id: "b02655a1-2afa-e811-a981-000d3a276620",
        accepted_policy_id: "4872c8ed-0229-f111-8342-7c1e5285e3ab",
        address_line_1: "123 Main St",
        address_city: "London",
        address_state_or_province: "London",
        address_postcode: "SW1A 1AA",
        telephone: "01234567890",
        has_dbs_certificate: true,
      }
    end

    it "returns a Faraday response with the candidate body" do
      response = resource.create_candidate(body)
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eq(201)
      expect(response.body).to be_a(Hash)
      expect(response.body).to include("candidateId", "email", "firstName", "lastName")
    end
  end
end
