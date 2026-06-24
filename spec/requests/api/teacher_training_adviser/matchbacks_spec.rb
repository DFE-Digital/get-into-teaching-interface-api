require "rails_helper"

RSpec.describe "POST /api/teacher_training_adviser/matchbacks", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  let(:valid_attributes) do
    {
      email: "test@example.com",
      first_name: "First Name",
      last_name: "Last name",
      date_of_birth: "2000-01-01",
      reference: "ref",
    }
  end

  describe "when the request is valid" do
    let(:crm_response) do
      CRM::Resources::TeacherTrainingAdviser::CandidateResource.new(
        candidate_id: "abc-123", qualification_id: nil, subject_taught_id: nil,
        past_teaching_position_id: nil, preferred_teaching_subject_id: nil,
        country_id: nil, accepted_policy_id: nil, type_id: nil, uk_degree_grade_id: nil,
        degree_type_id: nil, initial_teacher_training_year_id: nil, stage_taught_id: nil,
        preferred_education_phase_id: nil, has_gcse_maths_and_english_id: nil,
        has_gcse_science_id: nil, planning_to_retake_gcse_maths_and_english_id: nil,
        planning_to_retake_gcse_science_id: nil, adviser_status_id: nil, channel_id: nil,
        degree_country: nil, creation_channel_source_id: nil, creation_channel_service_id: nil,
        creation_channel_activity_id: nil, email: "test@example.com", first_name: nil,
        last_name: nil, date_of_birth: nil, teacher_id: nil, degree_subject: nil,
        address_telephone: nil, address_postcode: nil, phone_call_scheduled_at: nil,
        can_subscribe_to_teacher_training_adviser: false, assignment_status_id: nil,
        default_contact_creation_channel: nil, default_creation_channel_source_id: nil,
        default_creation_channel_service_id: nil, default_creation_channel_activity_id: nil,
        graduation_year: nil, inferred_graduation_date: nil, situation: nil, citizenship: nil,
        visa_status: nil, location: nil, degree_status_id: nil
      )
    end
    let(:candidate_resource) do
      instance_double(CRM::Adapters::GetIntoTeaching::Resources::TeacherTrainingAdviser::Resource)
    end
    let(:crm_client) { instance_double(CRM::Client, teacher_training_adviser: candidate_resource) }

    before do
      allow(candidate_resource).to receive(:matchback).and_return(crm_response)
      allow(CRM::Client).to receive(:new).and_return(crm_client)
    end

    it "performs the matchback and returns the CRM response" do
      post(api_teacher_training_adviser_matchbacks_path,
           params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to include("candidate_id" => "abc-123")
    end
  end

  describe "when params are invalid" do
    let(:invalid_attributes) do
      { matchback: { email: "bad" } }
    end

    it "returns validation errors" do
      post(api_teacher_training_adviser_matchbacks_path,
           params: invalid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:bad_request)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to have_key("errors")
    end
  end
end
