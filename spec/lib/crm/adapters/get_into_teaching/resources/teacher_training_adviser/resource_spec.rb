require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::TeacherTrainingAdviser::Resource do
  let(:client) { CRM::Adapters::GetIntoTeaching::Client.new }

  subject(:resource) { described_class.new(client) }

  describe "#create_candidate", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/teacher_training_adviser/candidates" } do
    let(:body) do
      {
        email: "test@example.com",
        first_name: "John",
        last_name: "Doe",
        date_of_birth: "1990-01-01",
        accepted_policy_id: "abc-123",
        country_id: "uk",
        type_id: "type-1",
      }
    end

    it "returns a Faraday response" do
      response = resource.create_candidate(body)
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eq(200)
    end
  end

  describe "#matchback", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/teacher_training_adviser/matchback" } do
    let(:body) do
      {
        email: "johndoe@example.com",
        first_name: "John",
        last_name: "Doe",
        date_of_birth: "1990-01-01",
      }
    end

    it "returns a Faraday response" do
      response = resource.matchback(body)
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eq(200)
    end
  end

  describe "#exchange_access_token", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/teacher_training_adviser/exchange_access_token" } do
    let(:token) { "abc123" }
    let(:body) do
      {
        email: "johndoe@example.com",
        first_name: "John",
        last_name: "Doe",
        date_of_birth: "1990-01-01",
      }
    end

    it "returns a Faraday response" do
      response = resource.exchange_access_token(token, body)
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eq(200)
    end
  end
end
