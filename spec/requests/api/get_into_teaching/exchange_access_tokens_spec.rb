require "rails_helper"

RSpec.describe "POST /api/get_into_teaching/candidates/exchange_access_token", type: :request do
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
    let(:crm_response) do
      Data.define(:body).new(body: {
        "candidateId" => "551fee4b-9b6c-4cfc-a579-ed9bf9bcadbb",
        "qualificationId" => "72a05d00-60b5-49f3-b85e-f80f0d597c15",
        "subjectTaughtId" => nil,
        "pastTeachingPositionId" => nil,
        "preferredTeachingSubjectId" => "b02655a1-2afa-e811-a981-000d3a276620",
        "countryId" => "72f5c2e6-74f9-e811-a97a-000d3a2760f2",
        "acceptedPolicyId" => nil,
        "typeId" => 222750000,
        "ukDegreeGradeId" => 222750002,
        "degreeTypeId" => 222750000,
        "initialTeacherTrainingYearId" => 22304,
        "stageTaughtId" => nil,
        "preferredEducationPhaseId" => 222750000,
        "hasGcseMathsAndEnglishId" => 222750000,
        "hasGcseScienceId" => 222750000,
        "planningToRetakeGcseMathsAndEnglishId" => nil,
        "planningToRetakeGcseScienceId" => 222750001,
        "adviserStatusId" => nil,
        "channelId" => nil,
        "degreeCountry" => nil,
        "creationChannelSourceId" => nil,
        "creationChannelServiceId" => nil,
        "creationChannelActivityId" => nil,
        "email" => "johndoe@example.com",
        "firstName" => "john",
        "lastName" => "doe",
        "dateOfBirth" => "1980-06-06T00:00:00",
        "teacherId" => nil,
        "degreeSubject" => "Computing",
        "addressTelephone" => nil,
        "addressPostcode" => "W1 1ED",
        "phoneCallScheduledAt" => nil,
        "canSubscribeToTeacherTrainingAdviser" => false,
        "assignmentStatusId" => 222750001,
        "defaultContactCreationChannel" => 222750027,
        "defaultCreationChannelSourceId" => 222750003,
        "defaultCreationChannelServiceId" => 222750010,
        "defaultCreationChannelActivityId" => nil,
        "graduationYear" => nil,
        "inferredGraduationDate" => nil,
        "situation" => nil,
        "citizenship" => nil,
        "visaStatus" => nil,
        "location" => nil,
        "degreeStatusId" => 222750000,
      })
    end
    let(:get_into_teaching_resource) do
      instance_double(CRM::Adapters::GetIntoTeaching::Resources::GetIntoTeachingResource)
    end
    let(:crm_client) { instance_double(CRM::Client, get_into_teaching: get_into_teaching_resource) }

    before do
      allow(get_into_teaching_resource).to receive(:exchange_access_token).and_return(crm_response)
      allow(CRM::Client).to receive(:new).and_return(crm_client)
    end

    it "exchanges the access token and returns the CRM response" do
      post(api_get_into_teaching_exchange_access_token_path(access_token: "123456"),
           params: valid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to eq({
        "candidateId" => "551fee4b-9b6c-4cfc-a579-ed9bf9bcadbb",
        "qualificationId" => "72a05d00-60b5-49f3-b85e-f80f0d597c15",
        "subjectTaughtId" => nil,
        "pastTeachingPositionId" => nil,
        "preferredTeachingSubjectId" => "b02655a1-2afa-e811-a981-000d3a276620",
        "countryId" => "72f5c2e6-74f9-e811-a97a-000d3a2760f2",
        "acceptedPolicyId" => nil,
        "typeId" => 222750000,
        "ukDegreeGradeId" => 222750002,
        "degreeTypeId" => 222750000,
        "initialTeacherTrainingYearId" => 22304,
        "stageTaughtId" => nil,
        "preferredEducationPhaseId" => 222750000,
        "hasGcseMathsAndEnglishId" => 222750000,
        "hasGcseScienceId" => 222750000,
        "planningToRetakeGcseMathsAndEnglishId" => nil,
        "planningToRetakeGcseScienceId" => 222750001,
        "adviserStatusId" => nil,
        "channelId" => nil,
        "degreeCountry" => nil,
        "creationChannelSourceId" => nil,
        "creationChannelServiceId" => nil,
        "creationChannelActivityId" => nil,
        "email" => "johndoe@example.com",
        "firstName" => "john",
        "lastName" => "doe",
        "dateOfBirth" => "1980-06-06T00:00:00",
        "teacherId" => nil,
        "degreeSubject" => "Computing",
        "addressTelephone" => nil,
        "addressPostcode" => "W1 1ED",
        "phoneCallScheduledAt" => nil,
        "canSubscribeToTeacherTrainingAdviser" => false,
        "assignmentStatusId" => 222750001,
        "defaultContactCreationChannel" => 222750027,
        "defaultCreationChannelSourceId" => 222750003,
        "defaultCreationChannelServiceId" => 222750010,
        "defaultCreationChannelActivityId" => nil,
        "graduationYear" => nil,
        "inferredGraduationDate" => nil,
        "situation" => nil,
        "citizenship" => nil,
        "visaStatus" => nil,
        "location" => nil,
        "degreeStatusId" => 222750000,
      })
    end
  end

  describe "when params are invalid" do
    let(:invalid_attributes) { { email: "bad" } }

    it "returns validation errors" do
      post(api_get_into_teaching_exchange_access_token_path(access_token: "x"),
           params: invalid_attributes, headers:, as: :json)
      expect(response).to have_http_status(:bad_request)
      expect(response.content_type).to match(%r{application/json})
      expect(response.parsed_body).to have_key("errors")
    end
  end
end
