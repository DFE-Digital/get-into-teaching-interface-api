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

  describe "#generate_mapping_info" do
    it "returns an array of mapping info", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/operations/generate_mapping_info" } do
      result = resource.generate_mapping_info
      expect(result).to be_an(Array)
    end

    it "transforms keys to symbols", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/operations/generate_mapping_info" } do
      result = resource.generate_mapping_info
      expect(result.first.keys).to include(:class, :logical_name, :fields, :relationships)
    end

    it "deeply transforms nested keys to symbols", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/operations/generate_mapping_info" } do
      result = resource.generate_mapping_info
      fields = result.first[:fields]
      expect(fields.keys).to all(be_a(Symbol))
      expect(fields[:application_form_id][:name]).to eq("dfe_applyapplicationform")
    end
  end

  describe "#pause_crm_integration" do
    it "returns a response with status 204", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/operations/pause_crm_integration" } do
      response = resource.pause_crm_integration
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eq(204)
    end
  end

  describe "#resume_crm_integration" do
    it "returns a response with status 204", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/operations/resume_crm_integration" } do
      response = resource.resume_crm_integration
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eq(204)
    end
  end

  describe "#backfill_apply_candidates" do
    it "returns a response with status 204", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/operations/backfill_apply_candidates" } do
      response = resource.backfill_apply_candidates
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eq(204)
    end
  end

  describe "#backfill_apply_candidates_from_ids" do
    it "returns a response with status 204", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/operations/backfill_apply_candidates_from_ids" } do
      response = resource.backfill_apply_candidates_from_ids
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eq(204)
    end
  end
end
