require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Client do
  subject(:adapter) { described_class.new }

  describe "#lookup_items" do
    it "returns a GIT LookUpItemsResource" do
      expect(adapter.lookup_items).to be_a(CRM::Adapters::GetIntoTeaching::Resources::LookUpItemsResource)
    end
  end

  describe "#lookup_items.countries", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/countries" } do
    subject(:result) { adapter.lookup_items.countries.all }

    it "returns CountryResource instances" do
      expect(result).to all(be_a(CRM::Resources::LookUpItems::CountryResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::LookUpItems::CountryResource.new(
          id: "fdf3c2e6-74f9-e811-a97a-000d3a2760f2",
          value: "Afghanistan",
          iso_code: "AF"
        )
      )
    end

    it "handles entries with a null iso_code" do
      unknown = result.find { |c| c.value == "Unknown" }

      expect(unknown).not_to be_nil
      expect(unknown.iso_code).to be_nil
    end
  end

  describe "#lookup_items.degree_countries", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/degree_countries" } do
    subject(:result) { adapter.lookup_items.degree_countries.all }

    it "returns CountryResource instances" do
      expect(result).to all(be_a(CRM::Resources::LookUpItems::DegreeCountryResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
                                CRM::Resources::LookUpItems::DegreeCountryResource.new(
                                  id: "6f9e7b81-e44d-f011-877a-00224886d23e",
                                  value: "Another Country",
                                  iso_code: nil
                                )
                              )
    end

    it "handles entries with a null iso_code" do
      unknown = result.find { |c| c.value == "Another Country" }

      expect(unknown).not_to be_nil
      expect(unknown.iso_code).to be_nil
    end
  end

  describe "#lookup_items.teaching_subjects", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/teaching_subjects" } do
    subject(:result) { adapter.lookup_items.teaching_subjects.all }

    it "returns TeachingSubjectResource instances" do
      expect(result).to all(be_a(CRM::Resources::LookUpItems::TeachingSubjectResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
                                CRM::Resources::LookUpItems::TeachingSubjectResource.new(
                                  id: "6b793433-cd1f-e911-a979-000d3a20838a",
                                  value: "Art",
                                )
                              )
    end
  end

  describe "#pick_list_items.candidate.initial_teacher_training_years",
           vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/initial_teacher_training_years" } do
    subject(:result) { adapter.pick_list_items.candidate.initial_teacher_training_years.all }

    it "returns InitialTeacherTrainingYearResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::InitialTeacherTrainingYearResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
                                CRM::Resources::PickListItems::Candidate::InitialTeacherTrainingYearResource.new(
                                  id: 12907,
                                  value: "2009",
                                  )
                              )
    end
  end

  describe "#pick_list_items.candidate.preferred_education_phases", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/preferred_education_phases" } do
    subject(:result) { adapter.pick_list_items.candidate.preferred_education_phases.all }

    it "returns PreferredEducationPhaseResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::PreferredEducationPhaseResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Candidate::PreferredEducationPhaseResource.new(
          id: 222750000,
          value: "Primary",
        )
      )
    end
  end

  describe "#pick_list_items.candidate.channels", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/channels" } do
    subject(:result) { adapter.pick_list_items.candidate.channels.all }

    it "returns ChannelResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::ChannelResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Candidate::ChannelResource.new(
          id: 222750000,
          value: "Graduate Promotions Registration",
        )
      )
    end
  end

  describe "#pick_list_items.candidate.mailing_list_subscription_channels", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/mailing_list_subscription_channels" } do
    subject(:result) { adapter.pick_list_items.candidate.mailing_list_subscription_channels.all }

    it "returns MailingListSubscriptionChannelResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::MailingListSubscriptionChannelResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Candidate::MailingListSubscriptionChannelResource.new(
          id: 222750000,
          value: "GITIS Mailing List Service",
        )
      )
    end
  end

  describe "#pick_list_items.candidate.event_subscription_channels", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/event_subscription_channels" } do
    subject(:result) { adapter.pick_list_items.candidate.event_subscription_channels.all }

    it "returns EventSubscriptionChannelResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::EventSubscriptionChannelResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Candidate::EventSubscriptionChannelResource.new(
          id: 222750000,
          value: "GITIS Events Service",
        )
      )
    end
  end

  describe "#pick_list_items.candidate.teacher_training_adviser_subscription_channels", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/teacher_training_adviser_subscription_channels" } do
    subject(:result) { adapter.pick_list_items.candidate.teacher_training_adviser_subscription_channels.all }

    it "returns TeacherTrainingAdviserSubscriptionChannelResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::TeacherTrainingAdviserSubscriptionChannelResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Candidate::TeacherTrainingAdviserSubscriptionChannelResource.new(
          id: 222750000,
          value: "GITIS - TTA Service",
        )
      )
    end
  end

  describe "#pick_list_items.candidate.gcse_statuses", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/gcse_statuses" } do
    subject(:result) { adapter.pick_list_items.candidate.gcse_statuses.all }

    it "returns GcseStatusResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::GcseStatusResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Candidate::GcseStatusResource.new(
          id: 222750000,
          value: "Completed GCSE",
        )
      )
    end
  end

  describe "#pick_list_items.candidate.retake_gcse_statuses", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/retake_gcse_statuses" } do
    subject(:result) { adapter.pick_list_items.candidate.retake_gcse_statuses.all }

    it "returns RetakeGcseStatusResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::RetakeGcseStatusResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Candidate::RetakeGcseStatusResource.new(
          id: 222750000,
          value: "Planning on Retaking GCSE",
        )
      )
    end
  end

  describe "#pick_list_items.candidate.consideration_journey_stages", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/consideration_journey_stages" } do
    subject(:result) { adapter.pick_list_items.candidate.consideration_journey_stages.all }

    it "returns ConsiderationJourneyStageResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::ConsiderationJourneyStageResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Candidate::ConsiderationJourneyStageResource.new(
          id: 222750000,
          value: "It’s just an idea",
        )
      )
    end
  end

  describe "#pick_list_items.candidate.adviser_eligibilities", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/adviser_eligibilities" } do
    subject(:result) { adapter.pick_list_items.candidate.adviser_eligibilities.all }

    it "returns AdviserEligibilityResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::AdviserEligibilityResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Candidate::AdviserEligibilityResource.new(
          id: 222750000,
          value: "Yes",
        )
      )
    end
  end

  describe "#pick_list_items.candidate.adviser_requirements", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/adviser_requirements" } do
    subject(:result) { adapter.pick_list_items.candidate.adviser_requirements.all }

    it "returns AdviserRequirementResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::AdviserRequirementResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Candidate::AdviserRequirementResource.new(
          id: 222750000,
          value: "No",
        )
      )
    end
  end

  describe "#pick_list_items.candidate.types", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/types" } do
    subject(:result) { adapter.pick_list_items.candidate.types.all }

    it "returns TypeResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::TypeResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Candidate::TypeResource.new(
          id: 222750000,
          value: "ITT",
        )
      )
    end
  end

  describe "#pick_list_items.candidate.assignment_statuses", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/assignment_statuses" } do
    subject(:result) { adapter.pick_list_items.candidate.assignment_statuses.all }

    it "returns AssignmentStatusResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::AssignmentStatusResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Candidate::AssignmentStatusResource.new(
          id: 222750000,
          value: "Unassigned",
        )
      )
    end
  end

  describe "#pick_list_items.candidate.situations", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/situations" } do
    subject(:result) { adapter.pick_list_items.candidate.situations.all }

    it "returns SituationResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::SituationResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Candidate::SituationResource.new(
          id: 222750000,
          value: "16-18 years old and still in education",
        )
      )
    end
  end

  describe "#pick_list_items.candidate.citizenships", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/citizenships" } do
    subject(:result) { adapter.pick_list_items.candidate.citizenships.all }

    it "returns CitizenshipResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::CitizenshipResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Candidate::CitizenshipResource.new(
          id: 222750000,
          value: "UK citizen",
        )
      )
    end
  end
end
