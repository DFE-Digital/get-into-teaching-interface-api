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
      CRM::Resources::MailingList::CandidateResource.new(
        candidate_id: "abc-123", qualification_id: nil,
        preferred_teaching_subject_id: nil, accepted_policy_id: nil,
        consideration_journey_stage_id: nil, channel_id: nil,
        creation_channel_source_id: nil, creation_channel_service_id: nil,
        creation_channel_activity_id: nil, email: "test@example.com",
        first_name: nil, last_name: nil, address_postcode: nil,
        welcome_guide_variant: nil, already_subscribed_to_events: false,
        already_subscribed_to_mailing_list: false,
        already_subscribed_to_teacher_training_adviser: false,
        default_contact_creation_channel: nil,
        default_creation_channel_source_id: nil,
        default_creation_channel_service_id: nil,
        default_creation_channel_activity_id: nil,
        situation: nil, citizenship: nil, visa_status: nil, location: nil,
        graduation_year: nil, inferred_graduation_date: nil,
        degree_status_id: nil
      )
    end

    before do
      allow(mailing_list_resource).to receive(:exchange_access_token).and_return(response_double)
    end

    it "exchanges the access token and returns the CRM response" do
      post(api_mailing_list_exchange_access_token_path(access_token: "123456"),
           params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to include("candidate_id" => "abc-123")
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
