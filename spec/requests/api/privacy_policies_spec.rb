require "rails_helper"
require 'swagger_helper'

RSpec.describe "GET /api/privacy_policies/:id", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  describe "GET /api/privacy_policies/:id" do
    describe "response format" do
      it "returns JSON" do
        get(api_privacy_policy_path('example-id'), headers:)
        expect(response.content_type).to match(%r{application/json})
      end

      it "returns JSON even when the client requests HTML" do
        get api_privacy_policy_path('example-id'), headers: headers.merge({ "Accept" => "text/html" })

        expect(response.content_type).to match(%r{application/json})
      end

      it "returns a data envelope containing the object data" do
        get(api_privacy_policy_path('example-id'), headers:)
        body = response.parsed_body
        expect(body).to have_key("data")
        expect(body["data"]).to be_an(Hash)
      end

      it "returns items with id and value fields" do
        get(api_privacy_policy_path('example-id'), headers:)
        item = response.parsed_body["data"]
        expect(item).to include("id", "text", "created_at")
      end
    end

    describe "when the id is not found" do
      let(:privacy_policies_resource) { instance_double(CRM::Resources::PrivacyPoliciesResource) }
      let(:crm_client) { instance_double(CRM::Client, privacy_policies: privacy_policies_resource) }

      before do
        allow(privacy_policies_resource).to receive(:find)
                                              .and_raise(CRM::Adapters::GetIntoTeaching::Resource::NotFoundError)
        allow(CRM::Client).to receive(:new).and_return(crm_client)
      end

      it "returns 404" do
        get(api_privacy_policy_path('unknown-id'), headers:)
        expect(response).to have_http_status(:not_found)
      end

      it "returns JSON" do
        get(api_privacy_policy_path('unknown-id'), headers:)
        expect(response.content_type).to match(%r{application/json})
      end

      it "returns JSON even when the client requests HTML" do
        get api_privacy_policy_path('unknown-id'), headers: headers.merge({ "Accept" => "text/html" })

        expect(response.content_type).to match(%r{application/json})
      end

      it "returns a human-readable message via the translation" do
        get(api_privacy_policy_path('unknown-id'), headers:)
        expect(response.parsed_body.dig("error", "message")).to eq(
                                                                  "We could not find a privacy policy with a matching id of `unknown-id`. Please check the ID and try again."
                                                                )
      end

      it "returns the route resource name" do
        get(api_privacy_policy_path('unknown-id'), headers:)
        expect(response.parsed_body.dig("error", "resource")).to eq("privacy_policies")
      end

      it "returns the requested id" do
        get(api_privacy_policy_path('unknown-id'), headers:)
        expect(response.parsed_body.dig("error", "id")).to eq("unknown-id")
      end
    end

    describe "when the CRM is unavailable" do
      let(:privacy_policies_resource) { instance_double(CRM::Resources::PrivacyPoliciesResource) }
      let(:crm_client) { instance_double(CRM::Client, privacy_policies: privacy_policies_resource) }

      before do
        allow(privacy_policies_resource).to receive(:find)
                                              .and_raise(CRM::Adapters::GetIntoTeaching::Resource::Error)
        allow(CRM::Client).to receive(:new).and_return(crm_client)
      end

      it "returns 503" do
        get(api_privacy_policy_path('example-id'), headers:)
        expect(response).to have_http_status(:service_unavailable)
      end

      it "returns JSON" do
        get(api_privacy_policy_path('example-id'), headers:)
        expect(response.content_type).to match(%r{application/json})
      end

      it "returns a human-readable message" do
        get(api_privacy_policy_path('example-id'), headers:)
        expect(response.parsed_body.dig("error", "message")).to eq(
                                                                  "The upstream service is currently unavailable. Please try again later."
                                                                )
      end
    end
  end

  path '/api/privacy_policies/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show privacy_policy') do
      let(:Authorization) { "Bearer #{api_token}" }

      response(200, 'successful') do
        let(:id) { '4872c8ed-0229-f111-8342-7c1e5285e3ab' }

        schema type: :object,
               properties: {
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :string },
                     text: { type: :string },
                     created_at: { type: :string },

                   },
                   required: [ :id, :text, :created_at ],
                 },
               }

        example 'application/json', "4872c8ed-0229-f111-8342-7c1e5285e3ab", {
          data: {
            id: "4872c8ed-0229-f111-8342-7c1e5285e3ab",
            text: "This is a demo privacy policy for testing purposes.",
            created_at: "2026-04-30T09:36:47.357Z",
          },
        }

        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'unknown-id' }
        before do
          privacy_policies_resource = instance_double(CRM::Resources::PrivacyPoliciesResource)
          crm_client = instance_double(CRM::Client, privacy_policies: privacy_policies_resource)

          allow(privacy_policies_resource).to receive(:find)
                                                .and_raise(CRM::Adapters::GetIntoTeaching::Resource::NotFoundError)
          allow(CRM::Client).to receive(:new).and_return(crm_client)
        end

        example 'application/json', "4872c8ed-0229-f111-8342-7c1e5285e3ab", {
          error: {
            message: "We could not find a privacy policy with a matching id of `4872c8ed-0229-f111-8342-7c1e5285e3ab`. Please check the ID and try again.",
            resource: "privacy_policy",
            id: "4872c8ed-0229-f111-8342-7c1e5285e3ab",
          },
        }

        run_test!
      end
    end
  end
end
