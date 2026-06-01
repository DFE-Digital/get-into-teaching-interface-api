require "rails_helper"

RSpec.describe "POST /api/get_into_teaching/callbacks", type: :request do
  before { Rails.cache.clear }

  describe "response format" do
    it "returns JSON" do
      post api_get_into_teaching_callbacks_path

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns JSON even when the client requests HTML" do
      post api_get_into_teaching_callbacks_path, headers: { "Accept" => "text/html" }

      expect(response.content_type).to match(%r{application/json})
    end

    it "returns a data envelope" do
      post api_get_into_teaching_callbacks_path

      body = response.parsed_body
      expect(body).to have_key("data")
    end
  end
end
