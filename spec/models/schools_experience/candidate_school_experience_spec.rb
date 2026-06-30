require "rails_helper"

RSpec.describe SchoolsExperience::CandidateSchoolExperience do
  let(:request_params) do
    {
      id: "candidate-123",
      school_urn: "123456",
      duration_of_placement_in_days: 5,
      date_of_school_experience: "2026-09-15",
      teaching_subject_id: "subject-1",
      notes: "Student showed great interest.",
      school_name: "Example High School",
    }
  end
  let(:crm_client) { instance_double(CRM::Client) }
  let(:schools_experience_resource) do
    instance_double(CRM::Adapters::GetIntoTeaching::Resources::SchoolsExperienceResource)
  end

  subject do
    described_class.new(client: crm_client, request_params:)
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:id) }
    it { is_expected.to validate_presence_of(:school_urn) }
  end

  describe "#create" do
    before do
      allow(crm_client).to receive(:schools_experience).and_return(schools_experience_resource)
      allow(schools_experience_resource).to receive(:create_school_experience).and_return(true)
    end

    context "when valid" do
      it "calls the CRM client with the id and camelized body" do
        subject.create
        expect(schools_experience_resource).to have_received(:create_school_experience) do |id, body|
          expect(id).to eq("candidate-123")
          expect(body).to include(
            "schoolUrn" => "123456",
            "durationOfPlacementInDays" => 5,
            "dateOfSchoolExperience" => "2026-09-15",
            "teachingSubjectId" => "subject-1",
            "notes" => "Student showed great interest.",
            "schoolName" => "Example High School",
          )
        end
      end

      it "returns the response from the CRM client" do
        expect(subject.create).to be(true)
      end
    end

    context "when invalid" do
      let(:request_params) { {} }

      it "returns false without calling the CRM client" do
        subject.create
        expect(schools_experience_resource).not_to have_received(:create_school_experience)
      end

      it "populates errors" do
        subject.create
        expect(subject.errors).not_to be_empty
      end
    end
  end

  describe "body" do
    it "camelizes attribute keys and excludes id" do
      body = subject.send(:body)

      expect(body).to include(
        "schoolUrn" => "123456",
        "durationOfPlacementInDays" => 5,
        "dateOfSchoolExperience" => "2026-09-15",
        "teachingSubjectId" => "subject-1",
        "notes" => "Student showed great interest.",
        "schoolName" => "Example High School",
      )
      expect(body).not_to have_key("id")
    end
  end
end
