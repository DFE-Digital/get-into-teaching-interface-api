require "rails_helper"

RSpec.describe "GET /api/pick_list_items/contact_creation_channel/sources", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  describe "response format" do
    it "returns JSON" do
      get(api_pick_list_items_contact_creation_channel_sources_path, headers:)
      expect(response.content_type).to match(%r{application/json})
    end

    it "returns JSON even when the client requests HTML" do
      get api_pick_list_items_contact_creation_channel_sources_path, headers: headers.merge({ "Accept" => "text/html" })

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns a data envelope containing an array" do
      get(api_pick_list_items_contact_creation_channel_sources_path, headers:)
      body = response.parsed_body
      expect(body).to have_key("data")
      expect(body["data"]).to be_an(Array)
    end

    it "returns items with id and value fields" do
      get(api_pick_list_items_contact_creation_channel_sources_path, headers:)
      item = response.parsed_body["data"].first
      expect(item).to include("id", "value")
    end
  end
end
