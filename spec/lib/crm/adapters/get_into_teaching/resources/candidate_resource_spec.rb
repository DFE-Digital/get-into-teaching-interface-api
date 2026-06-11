require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::CandidatesResource do
  let(:client) { CRM::Adapters::GetIntoTeaching::Client.new }

  subject(:resource) { described_class.new(client) }

  describe "#create_access_token", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/candidates/access_token" } do
    let(:body) do
      {
        email: "johndoe@example.com",
        first_name: "John",
        last_name: "Doe",
        date_of_birth: "2000-01-01",
      }
    end

    it "returns a Faraday response" do
      response = resource.create_access_token(body)
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eq(204)
    end
  end
end
