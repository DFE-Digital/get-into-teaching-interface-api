require "rails_helper"

RSpec.describe "POST /api/schools_experience/candidates/exchange_access_token/:access_token", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  let(:valid_attributes) do
    {
      email: "test@example.com",
      first_name: "John",
      last_name: "Doe",
    }
  end

  describe "when the request is valid" do
    it "exchanges the access token and returns the CRM response" do
      post(api_schools_experience_exchange_access_token_path(access_token: "123456"),
           params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to include("candidateId")
    end
  end

  describe "when params are invalid" do
    let(:invalid_attributes) { { email: "bad" } }

    it "returns validation errors" do
      post(api_schools_experience_exchange_access_token_path(access_token: "x"),
           params: invalid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:bad_request)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to have_key("errors")
    end
  end
end
