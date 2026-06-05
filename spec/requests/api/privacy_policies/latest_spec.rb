require 'rails_helper'

RSpec.describe "GET /api/privacy_policies/latest", type: :request do
  include APIHelper
  before { Rails.cache.clear }

  describe "response format" do
    it "returns JSON" do
      get(api_privacy_policies_latest_path, headers:)

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns JSON even when the client requests HTML" do
      get api_privacy_policies_latest_path, headers: headers.merge({ "Accept" => "text/html" })

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns a data envelope containing the object data" do
      get(api_privacy_policies_latest_path, headers:)

      body = response.parsed_body
      expect(body).to have_key("data")
      expect(body["data"]).to be_an(Hash)
    end

    it "returns items with id and value fields" do
      get(api_privacy_policies_latest_path, headers:)

      item = response.parsed_body["data"]
      expect(item).to include("id", "text", "created_at")
    end
  end

  describe "when no auth token is provided" do
    it "returns 401" do
      get api_privacy_policies_latest_path

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns a human-readable message" do
      get api_privacy_policies_latest_path

      expect(response.parsed_body.dig("errors", 0, "message")).to eq(
        "Please provide a valid authentication token"
      )
    end
  end

  describe "when the latest policy is not found" do
    let(:privacy_policies_resource) { instance_double(CRM::Resources::PrivacyPoliciesResource) }
    let(:crm_client) { instance_double(CRM::Client, privacy_policies: privacy_policies_resource) }

    before do
      allow(privacy_policies_resource).to receive(:find)
        .and_raise(CRM::Adapters::GetIntoTeaching::Resource::NotFoundError)
      allow(CRM::Client).to receive(:new).and_return(crm_client)
    end

    it "returns 404" do
      get(api_privacy_policies_latest_path, headers:)

      expect(response).to have_http_status(:not_found)
    end

    it "returns JSON" do
      get(api_privacy_policies_latest_path, headers:)

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns the privacy_policies resource name" do
      get(api_privacy_policies_latest_path, headers:)

      expect(response.parsed_body.dig("error", "resource")).to eq("privacy_policies")
    end

    it "returns latest as the id" do
      get(api_privacy_policies_latest_path, headers:)

      expect(response.parsed_body.dig("error", "id")).to eq("latest")
    end

    it "returns a human-readable message" do
      get(api_privacy_policies_latest_path, headers:)

      expect(response.parsed_body.dig("error", "message")).to eq(
        "We could not find a privacy policy with a matching id of `latest`. Please check the ID and try again."
      )
    end
  end
end
