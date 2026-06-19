require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::GetIntoTeachingResource do
  let(:client) { CRM::Adapters::GetIntoTeaching::Client.new }

  subject(:resource) { described_class.new(client) }

  describe "#create_callback", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/get_into_teaching/create_callback" } do
    let(:body) do
      {
        email: "johndoe@example.com",
        first_name: "John",
        last_name: "Doe",
        address_telephone: "07735 111111",
        phone_call_scheduled_at: "2026-06-16T14:00:00Z",
        talking_points: "I would like to discuss teaching as a career.",
        accepted_policy_id: "4872c8ed-0229-f111-8342-7c1e5285e3ab",
        candidate_id: "d85a2f0b-290f-4931-98e2-e7d817ac38f3",
      }
    end

    it "returns a Faraday response with no content" do
      response = resource.create_callback(body)
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eq(204)
      expect(response.body).to be_empty
    end
  end

  describe "#matchback", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/get_into_teaching/matchback" } do
    let(:body) do
      {
        email: "johndoe@example.com",
        first_name: "John",
        last_name: "Doe",
        date_of_birth: "1990-01-01",
      }
    end

    it "returns a Faraday response with the candidate body" do
      response = resource.matchback(body)
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eq(200)
      expect(response.body).to be_a(Hash)
      expect(response.body).to include("candidateId", "email", "firstName", "lastName")
      expect(response.body["email"]).to eq("johndoe@example.com")
      expect(response.body["firstName"]).to eq("John")
      expect(response.body["lastName"]).to eq("Doe")
    end
  end

  describe "#exchange_access_token", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/get_into_teaching/exchange_access_token" } do
    let(:token) { "abc123" }
    let(:body) do
      {
        email: "johndoe@example.com",
        first_name: "John",
        last_name: "Doe",
        date_of_birth: "1990-01-01",
      }
    end

    it "returns a Faraday response with the candidate body" do
      response = resource.exchange_access_token(token, body)
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eq(200)
      expect(response.body).to be_a(Hash)
      expect(response.body).to include("candidateId", "email", "firstName", "lastName")
      expect(response.body["candidateId"]).to eq("551fee4b-9b6c-4cfc-a579-ed9bf9bcadbb")
    end
  end
end
