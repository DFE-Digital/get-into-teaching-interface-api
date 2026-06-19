require "rails_helper"

RSpec.describe "POST /api/get_into_teaching/callbacks", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  let(:valid_attributes) do
    {
      email: "test@example.com",
      first_name: "First Name",
      last_name: "Last Name",
      address_telephone: "07735 111111",
      phone_call_scheduled_at: "2026-06-16T14:00:00Z",
      talking_points: "I would like to discuss teaching as a career.",
      accepted_policy_id: "4872c8ed-0229-f111-8342-7c1e5285e3ab",
      candidate_id: "d85a2f0b-290f-4931-98e2-e7d817ac38f3",
    }
  end

  describe "when the request is valid" do
    let(:crm_response) { instance_double(Faraday::Response, status: 204) }
    let(:get_into_teaching_resource) do
      instance_double(CRM::Adapters::GetIntoTeaching::Resources::GetIntoTeachingResource)
    end
    let(:crm_client) { instance_double(CRM::Client, get_into_teaching: get_into_teaching_resource) }

    before do
      allow(get_into_teaching_resource).to receive(:create_callback).and_return(crm_response)
      allow(CRM::Client).to receive(:new).and_return(crm_client)
    end

    it "sends the request and gets CRM response" do
      post(api_get_into_teaching_callbacks_path, params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(%r{application/json})
      expect(response.status).to eq(200)
    end
  end

  describe "when params are invalid" do
    let(:invalid_attributes) { { email: "bad" } }

    it "returns validation errors" do
      post(api_get_into_teaching_callbacks_path, params: invalid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:bad_request)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to have_key("errors")
    end
  end
end
