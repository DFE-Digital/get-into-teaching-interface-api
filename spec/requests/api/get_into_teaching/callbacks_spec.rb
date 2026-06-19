require 'rails_helper'

RSpec.describe "API::GetIntoTeaching::Callbacks", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/api/get_into_teaching/callbacks/create"
      expect(response).to have_http_status(:success)
    end
  end

end
