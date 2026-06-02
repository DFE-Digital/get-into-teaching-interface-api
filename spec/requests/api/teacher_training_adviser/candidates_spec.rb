require "rails_helper"

RSpec.describe "POST /api/teacher_training_adviser/candidates", type: :request do
  before { Rails.cache.clear }

  describe "response format" do
    it "returns JSON" do
      post api_teacher_training_adviser_candidates_path

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns JSON even when the client requests HTML" do
      post api_teacher_training_adviser_candidates_path, headers: { "Accept" => "text/html" }

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns a data envelope" do
      post api_teacher_training_adviser_candidates_path

      body = response.parsed_body
      expect(body).to have_key("data")
    end
  end
end
