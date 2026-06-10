require "rails_helper"

RSpec.describe "GET /api/lookup_items/teaching_subjects", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  describe "response format" do
    it "returns JSON" do
      get(api_lookup_items_teaching_subjects_path, headers:)
      expect(response.content_type).to match(%r{application/json})
    end

    it "returns JSON even when the client requests HTML" do
      get api_lookup_items_teaching_subjects_path, headers: headers.merge({ "Accept" => "text/html" })

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns a data envelope containing an array of teaching subjects" do
      get(api_lookup_items_teaching_subjects_path, headers:)
      body = response.parsed_body
      expect(body).to be_an(Array)
    end

    it "returns teaching subjects with id, value, and iso_code fields" do
      get(api_lookup_items_teaching_subjects_path, headers:)
      country = response.parsed_body.first
      expect(country).to include("id", "value")
    end
  end
end
