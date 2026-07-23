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
end
