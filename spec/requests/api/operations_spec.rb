require "rails_helper"

RSpec.describe "API::Operations", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  let(:operation_resource) do
    instance_double(CRM::Adapters::GetIntoTeaching::Resources::OperationResource)
  end

  let(:crm_client) { instance_double(CRM::Client, operations: operation_resource) }

  before do
    allow(CRM::Client).to receive(:new).and_return(crm_client)
  end

  describe "GET /api/operations/health_check" do
    let(:health_check_data) do
      CRM::Resources::Operations::HealthCheckResource.new(
        git_commit_sha: "abc123",
        environment: "test",
        database: "ok",
        hangfire: "ok",
        crm: "ok",
        redis: "ok",
        notify: "ok",
        status: "healthy",
      )
    end

    before do
      allow(operation_resource).to receive(:health_check).and_return(health_check_data)
    end

    it "returns JSON" do
      get(api_operations_health_check_path, headers:)
      expect(response.content_type).to match(%r{application/json})
    end

    it "returns health check data" do
      get(api_operations_health_check_path, headers:)
      body = response.parsed_body
      expect(body).to include(
        "git_commit_sha" => "abc123",
        "environment" => "test",
        "status" => "healthy",
      )
    end
  end

  describe "GET /api/operations/generate_mapping_info" do
    let(:mapping_data) do
      [
        { "class" => "Candidate", "logical_name" => "contact" },
        { "class" => "TeachingEvent", "logical_name" => "msevtmgt_event" },
      ]
    end

    before do
      allow(operation_resource).to receive(:generate_mapping_info).and_return(mapping_data)
    end

    it "returns JSON" do
      get(api_operations_generate_mapping_info_path, headers:)
      expect(response.content_type).to match(%r{application/json})
    end

    it "returns an array of mapping info" do
      get(api_operations_generate_mapping_info_path, headers:)
      body = response.parsed_body
      expect(body).to be_an(Array)
      expect(body.first).to include("class" => "Candidate", "logical_name" => "contact")
    end
  end

  describe "PUT /api/operations/pause_crm_integration" do
    before do
      allow(operation_resource).to receive(:pause_crm_integration).and_return(true)
    end

    it "returns no content" do
      put(api_operations_pause_crm_integration_path, headers:)
      expect(response).to have_http_status(:no_content)
      expect(response.status).to eq(204)
    end
  end

  describe "PUT /api/operations/resume_crm_integration" do
    before do
      allow(operation_resource).to receive(:resume_crm_integration).and_return(true)
    end

    it "returns no content" do
      put(api_operations_resume_crm_integration_path, headers:)
      expect(response).to have_http_status(:no_content)
      expect(response.status).to eq(204)
    end
  end

  describe "POST /api/operations/backfill_apply_candidates" do
    before do
      allow(operation_resource).to receive(:backfill_apply_candidates).and_return(true)
    end

    it "returns no content when updated_since is provided" do
      post(api_operations_backfill_apply_candidates_path,
           params: { updated_since: "2026-06-22T00:00:00Z" },
           headers:,
           as: :json)
      expect(response).to have_http_status(:no_content)
      expect(response.status).to eq(204)
    end

    it "returns bad request when updated_since is missing" do
      post(api_operations_backfill_apply_candidates_path, headers:, as: :json)
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "POST /api/operations/backfill_apply_candidates_from_ids" do
    before do
      allow(operation_resource).to receive(:backfill_apply_candidates_from_ids).and_return(true)
    end

    it "returns no content when candidate_ids is provided" do
      post(api_operations_backfill_apply_candidates_from_ids_path,
           params: { candidate_ids: [ 123, 456 ] },
           headers:,
           as: :json)
      expect(response).to have_http_status(:no_content)
      expect(response.status).to eq(204)
    end

    it "returns bad request when candidate_ids is missing" do
      post(api_operations_backfill_apply_candidates_from_ids_path, headers:, as: :json)
      expect(response).to have_http_status(:bad_request)
    end
  end
end
