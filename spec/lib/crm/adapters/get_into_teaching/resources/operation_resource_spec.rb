require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::OperationResource do
  let(:base_url) { "https://test.example.com" }
  let(:client) { CRM::Adapters::GetIntoTeaching::Client.new(base_url:, api_key: "test-key") }

  subject(:resource) { described_class.new(client) }

  describe "#health_check" do
    it "returns a HealthCheckResource instance", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/operations/health_check" } do
      result = resource.health_check
      expect(result).to be_a(CRM::Resources::Operations::HealthCheckResource)
    end

    it "deserializes the response correctly", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/operations/health_check" } do
      result = resource.health_check
      expect(result.git_commit_sha).to eq("2bf37a2")
      expect(result.environment).to eq("Staging")
      expect(result.database).to eq("ok")
      expect(result.hangfire).to eq("ok")
      expect(result.crm).to eq("ok")
      expect(result.redis).to eq("ok")
      expect(result.notify).to eq("ok")
      expect(result.status).to eq("healthy")
    end
  end
end
