require "rails_helper"

RSpec.describe "POST /api/mailing_list/members", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  let(:valid_attributes) do
    {
      email: "test@example.com",
      first_name: "John",
      last_name: "Doe",
      accepted_policy_id: "abc-123",
      consideration_journey_stage_id: 222750000,
      preferred_teaching_subject_id: "subject-1",
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
      CRM::Resources::TeacherTrainingAdviser::DegreeResource.new(
        degree_status_id: 222750000
      )
    end

    before do
      allow(mailing_list_resource).to receive(:create_member).and_return(response_double)
    end

    it "adds the member to the mailing list and returns the response" do
      post(api_mailing_list_members_path,
           params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to include("degree_status_id" => 222750000)
    end
  end

  describe "when params are invalid" do
    let(:invalid_attributes) do
      { email: "bad" }
    end

    it "returns validation errors" do
      post(api_mailing_list_members_path,
           params: invalid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:bad_request)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to have_key("errors")
    end
  end

  describe "when the CRM is unavailable" do
    before do
      allow(mailing_list_resource).to receive(:create_member)
                                      .and_raise(CRM::Adapters::GetIntoTeaching::Resource::Error)
    end

    it "returns 503" do
      post(api_mailing_list_members_path,
           params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:service_unavailable)
    end
  end
end
