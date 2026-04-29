require "rails_helper"

RSpec.describe "GET /api/pick_list_items/candidate/consideration_journey_stages", type: :request do
  before { Rails.cache.clear }

  describe "response format" do
    it "returns JSON" do
      get api_pick_list_items_candidate_consideration_journey_stages_path

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns JSON even when the client requests HTML" do
      get api_pick_list_items_candidate_consideration_journey_stages_path, headers: { "Accept" => "text/html" }

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns a data envelope containing an array" do
      get api_pick_list_items_candidate_consideration_journey_stages_path

      body = response.parsed_body
      expect(body).to have_key("data")
      expect(body["data"]).to be_an(Array)
    end

    it "returns items with id and value fields" do
      get api_pick_list_items_candidate_consideration_journey_stages_path

      item = response.parsed_body["data"].first
      expect(item).to include("id", "value")
    end
  end
end
