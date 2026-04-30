require "rails_helper"

RSpec.describe "GET /api/privacy_policies/:id", type: :request do
  before { Rails.cache.clear }

  describe "response format" do
    it "returns JSON" do
      get api_privacy_policy_path('example-id')

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns JSON even when the client requests HTML" do
      get api_privacy_policy_path('example-id'), headers: { "Accept" => "text/html" }

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns a data envelope containing the object data" do
      get api_privacy_policy_path('example-id')

      body = response.parsed_body
      expect(body).to have_key("data")
      expect(body["data"]).to be_an(Hash)
    end

    it "returns items with id and value fields" do
      get api_privacy_policy_path('example-id')

      item = response.parsed_body["data"]
      expect(item).to include("id", "text", "created_at")
    end
  end
end
