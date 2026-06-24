require "rails_helper"

RSpec.describe "POST /api/teacher_training_adviser/exchange_access_tokens", type: :request do
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

  describe "when the request is valid" do
    it "exchanges the access token and returns the CRM response" do
      post(api_teacher_training_adviser_exchange_access_token_path(access_token: "123456"),
           params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to eq({
        "candidate_id" => "551fee4b-9b6c-4cfc-a579-ed9bf9bcadbb",
        "qualification_id" => "72a05d00-60b5-49f3-b85e-f80f0d597c15",
        "subject_taught_id" => nil,
        "past_teaching_position_id" => nil,
        "preferred_teaching_subject_id" => "b02655a1-2afa-e811-a981-000d3a276620",
        "country_id" => "72f5c2e6-74f9-e811-a97a-000d3a2760f2",
        "accepted_policy_id" => nil,
        "type_id" => 222750000,
        "uk_degree_grade_id" => 222750002,
        "degree_type_id" => 222750000,
        "initial_teacher_training_year_id" => 22304,
        "stage_taught_id" => nil,
        "preferred_education_phase_id" => 222750000,
        "has_gcse_maths_and_english_id" => 222750000,
        "has_gcse_science_id" => 222750000,
        "planning_to_retake_gcse_maths_and_english_id" => nil,
        "planning_to_retake_gcse_science_id" => 222750001,
        "adviser_status_id" => nil,
        "channel_id" => nil,
        "degree_country" => nil,
        "creation_channel_source_id" => nil,
        "creation_channel_service_id" => nil,
        "creation_channel_activity_id" => nil,
        "email" => "johndoe@example.com",
        "first_name" => "john",
        "last_name" => "doe",
        "date_of_birth" => "1980-06-06T00:00:00",
        "teacher_id" => nil,
        "degree_subject" => "Computing",
        "address_telephone" => nil,
        "address_postcode" => "W1 1ED",
        "phone_call_scheduled_at" => nil,
        "can_subscribe_to_teacher_training_adviser" => false,
        "assignment_status_id" => 222750001,
        "default_contact_creation_channel" => 222750027,
        "default_creation_channel_source_id" => 222750003,
        "default_creation_channel_service_id" => 222750010,
        "default_creation_channel_activity_id" => nil,
        "graduation_year" => nil,
        "inferred_graduation_date" => nil,
        "situation" => nil,
        "citizenship" => nil,
        "visa_status" => nil,
        "location" => nil,
        "degree_status_id" => 222750000,
      })
    end
  end

  describe "when params are invalid" do
    let(:invalid_attributes) { { email: "bad" } }

    it "returns validation errors" do
      post(api_teacher_training_adviser_exchange_access_token_path(access_token: "x"),
           params: invalid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:bad_request)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to have_key("errors")
    end
  end
end
