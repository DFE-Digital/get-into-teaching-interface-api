require "rails_helper"

RSpec.describe "API::SchoolsExperience::CandidateSchoolExperiences", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  let(:valid_attributes) do
    {
      school_urn: "123456",
      duration_of_placement_in_days: 5,
      date_of_school_experience: "2026-09-15",
      teaching_subject_id: "subject-1",
      notes: "Student showed great interest.",
      school_name: "Example High School",
    }
  end

  describe "POST /api/schools_experience/candidates/:id/school_experience" do
    describe "when the request is valid" do
      it "returns 204 no content" do
        post(
          school_experience_api_schools_experience_candidate_path("1"),
          params: valid_attributes,
          headers:,
          as: :json,
        )
        expect(response).to have_http_status(:no_content)
      end
    end

    describe "when params are invalid" do
      let(:invalid_attributes) do
        { school_urn: nil }
      end

      it "returns validation errors" do
        post(
          school_experience_api_schools_experience_candidate_path("1"),
          params: invalid_attributes,
          headers:,
          as: :json,
        )
        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to match(%r{application/json})
        expect(response.parsed_body).to have_key("errors")
      end
    end

    describe "when the CRM is unavailable" do
      let(:schools_experience_resource) do
        instance_double(CRM::Adapters::GetIntoTeaching::Resources::SchoolsExperienceResource)
      end
      let(:crm_client) { instance_double(CRM::Client, schools_experience: schools_experience_resource) }

      before do
        allow(schools_experience_resource).to receive(:create_school_experience)
                                              .and_raise(CRM::Adapters::GetIntoTeaching::Resource::Error)
        allow(CRM::Client).to receive(:new).and_return(crm_client)
      end

      it "returns 503" do
        post(
          school_experience_api_schools_experience_candidate_path("1"),
          params: valid_attributes,
          headers:,
          as: :json,
        )
        expect(response).to have_http_status(:service_unavailable)
      end
    end
  end
end
