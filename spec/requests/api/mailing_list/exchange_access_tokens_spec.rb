require "rails_helper"

RSpec.describe "POST /api/mailing_list/members/exchange_access_token", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  let(:valid_attributes) do
    {
      email: "test@example.com",
      first_name: "First Name",
      last_name: "Last name",
      date_of_birth: "2000-01-01",
    }
  end

  let(:mailing_list_resource) do
    instance_double(CRM::Adapters::GetIntoTeaching::Resources::MailingListResource)
  end

  let(:crm_client) { instance_double(CRM::Client, mailing_list: mailing_list_resource) }

  before do
    allow(CRM::Client).to receive(:new).and_return(crm_client)
  end

  describe "when the request is valid" do
    let(:response_double) do
      instance_double(Faraday::Response, body: { "degreeStatusId" => 222750000 })
    end

    before do
      allow(mailing_list_resource).to receive(:exchange_access_token).and_return(response_double)
    end

    it "exchanges the access token and returns the CRM response" do
      post(api_mailing_list_exchange_access_token_path(access_token: "123456"),
           params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to include("degreeStatusId" => 222750000)
    end
  end

  describe "when params are invalid" do
    let(:invalid_attributes) { { email: "bad" } }

    it "returns validation errors" do
      post(api_mailing_list_exchange_access_token_path(access_token: "x"),
           params: invalid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:bad_request)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to have_key("errors")
    end
  end

  describe "when the CRM is unavailable" do
    before do
      allow(mailing_list_resource).to receive(:exchange_access_token)
                                      .and_raise(CRM::Adapters::GetIntoTeaching::Resource::Error)
    end

    it "returns 503" do
      post(api_mailing_list_exchange_access_token_path(access_token: "123456"),
           params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:service_unavailable)
    end
  end
end
