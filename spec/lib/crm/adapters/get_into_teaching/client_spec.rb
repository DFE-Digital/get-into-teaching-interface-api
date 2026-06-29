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

    it "handles entries with a nil iso_code" do
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

    it "handles entries with a nil iso_code" do
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

  describe "#pick_list_items.candidate.visa_statuses", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/visa_statuses" } do
    subject(:result) { adapter.pick_list_items.candidate.visa_statuses.all }

    it "returns VisaStatusResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::VisaStatusResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Candidate::VisaStatusResource.new(
          id: 222750000,
          value: "Yes, I have a visa, pre-settled status or leave to remain",
        )
      )
    end
  end

  describe "#pick_list_items.candidate.locations", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/locations" } do
    subject(:result) { adapter.pick_list_items.candidate.locations.all }

    it "returns LocationResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::LocationResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Candidate::LocationResource.new(
          id: 222750000,
          value: "United Kingdom",
        )
      )
    end
  end

  describe "#pick_list_items.candidate.has_qualified_teacher_statuses", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/has_qualified_teacher_statuses" } do
    subject(:result) { adapter.pick_list_items.candidate.has_qualified_teacher_statuses.all }

    it "returns HasQualifiedTeacherStatusResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::HasQualifiedTeacherStatusResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Candidate::HasQualifiedTeacherStatusResource.new(
          id: 222750000,
          value: "No",
        )
      )
    end
  end

  describe "#pick_list_items.qualification.degree_statuses", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/degree_statuses" } do
    subject(:result) { adapter.pick_list_items.qualification.degree_statuses.all }

    it "returns DegreeStatusResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Qualification::DegreeStatusResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Qualification::DegreeStatusResource.new(
          id: 222750000,
          value: "Graduate or postgraduate",
        )
      )
    end
  end

  describe "#pick_list_items.qualification.types", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/qualification/types" } do
    subject(:result) { adapter.pick_list_items.qualification.types.all }

    it "returns TypeResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Qualification::TypeResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Qualification::TypeResource.new(
          id: 222750000,
          value: "Degree",
        )
      )
    end
  end

  describe "#pick_list_items.qualification.uk_degree_grades", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/uk_degree_grades" } do
    subject(:result) { adapter.pick_list_items.qualification.uk_degree_grades.all }

    it "returns UkDegreeGradeResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::Qualification::UkDegreeGradeResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::Qualification::UkDegreeGradeResource.new(
          id: 222750000,
          value: "Not applicable",
        )
      )
    end
  end

  describe "#pick_list_items.past_teaching_position.education_phases", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/education_phases" } do
    subject(:result) { adapter.pick_list_items.past_teaching_position.education_phases.all }

    it "returns EducationPhaseResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::PastTeachingPosition::EducationPhaseResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::PastTeachingPosition::EducationPhaseResource.new(
          id: 222750000,
          value: "Primary",
        )
      )
    end
  end

  describe "#pick_list_items.teaching_event.types", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/pick_list_items/teaching_event/types" } do
    subject(:result) { adapter.pick_list_items.teaching_event.types.all }

    it "returns TypeResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::TeachingEvent::TypeResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::TeachingEvent::TypeResource.new(
          id: 222750000,
          value: "Application Workshop",
        )
      )
    end
  end

  describe "#pick_list_items.teaching_event.regions", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/pick_list_items/teaching_event/regions" } do
    subject(:result) { adapter.pick_list_items.teaching_event.regions.all }

    it "returns RegionResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::TeachingEvent::RegionResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::TeachingEvent::RegionResource.new(
          id: 222750000,
          value: "East Midlands",
        )
      )
    end
  end

  describe "#pick_list_items.teaching_event.statuses", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/pick_list_items/teaching_event/statuses" } do
    subject(:result) { adapter.pick_list_items.teaching_event.statuses.all }

    it "returns StatusResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::TeachingEvent::StatusResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::TeachingEvent::StatusResource.new(
          id: 222750000,
          value: "Open",
        )
      )
    end
  end

  describe "#pick_list_items.teaching_event.registration_channels", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/pick_list_items/teaching_event/registration_channels" } do
    subject(:result) { adapter.pick_list_items.teaching_event.registration_channels.all }

    it "returns RegistrationChannelResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::TeachingEvent::RegistrationChannelResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::TeachingEvent::RegistrationChannelResource.new(
          id: 222750000,
          value: "Online event RVSP",
        )
      )
    end
  end

  describe "#pick_list_items.phone_call.channels", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/pick_list_items/phone_call/channels" } do
    subject(:result) { adapter.pick_list_items.phone_call.channels.all }

    it "returns ChannelResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::PhoneCall::ChannelResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::PhoneCall::ChannelResource.new(
          id: 222750000,
          value: "Callback request",
        )
      )
    end
  end

  describe "#pick_list_items.service_subscription.types", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/pick_list_items/service_subscription/types" } do
    subject(:result) { adapter.pick_list_items.service_subscription.types.all }

    it "returns TypeResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::ServiceSubscription::TypeResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::ServiceSubscription::TypeResource.new(
          id: 222750000,
          value: "EVENT",
        )
      )
    end
  end

  describe "#pick_list_items.contact_creation_channel.sources", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/pick_list_items/contact_creation_channel/sources" } do
    subject(:result) { adapter.pick_list_items.contact_creation_channel.sources.all }

    it "returns SourceResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::ContactCreationChannel::SourceResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::ContactCreationChannel::SourceResource.new(
          id: 222750000,
          value: "Apply",
        )
      )
    end
  end

  describe "#pick_list_items.contact_creation_channel.services", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/pick_list_items/contact_creation_channel/services" } do
    subject(:result) { adapter.pick_list_items.contact_creation_channel.services.all }

    it "returns ServiceResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::ContactCreationChannel::ServiceResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::ContactCreationChannel::ServiceResource.new(
          id: 222750000,
          value: "Created on Apply",
        )
      )
    end
  end

  describe "#pick_list_items.contact_creation_channel.activities", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/pick_list_items/contact_creation_channel/activities" } do
    subject(:result) { adapter.pick_list_items.contact_creation_channel.activities.all }

    it "returns ActivityResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::ContactCreationChannel::ActivityResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::ContactCreationChannel::ActivityResource.new(
          id: 222750000,
          value: "Brand ambassador activity",
        )
      )
    end
  end

  describe "#pick_list_items.teaching_event.accessibility_items", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/pick_list_items/teaching_event/accessibility_items" } do
    subject(:result) { adapter.pick_list_items.teaching_event.accessibility_items.all }

    it "returns AccessibilityItemResource instances" do
      expect(result).to all(be_a(CRM::Resources::PickListItems::TeachingEvent::AccessibilityItemResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::PickListItems::TeachingEvent::AccessibilityItemResource.new(
          id: 222750000,
          value: "Wheelchair accessible",
        )
      )
    end
  end

  describe "#callback_booking_quotas", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/callback_booking_quotas" } do
    subject(:result) { adapter.callback_booking_quotas.all }

    it "returns CallbackBookingQuotaResource instances" do
      expect(result).to all(be_a(CRM::Resources::CallbackBookingQuotaResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::CallbackBookingQuotaResource.new(
          time_slot: "9am - 9:30am",
          day: "Thursday 30 April",
          start_at: "2026-04-30T08:00:00Z",
          end_at: "2026-04-30T08:30:00Z",
          number_of_bookings: 0,
          quota: 20,
          is_available: true,
          id: "73bdc2c6-7fa3-f011-bbd3-6045bd9399eb"
        )
      )
    end
  end

  describe "#teaching_event_buildings", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/teaching_event_buildings" } do
    subject(:result) { adapter.teaching_event_buildings.all }

    it "returns TeachingEventBuildingResource instances" do
      expect(result).to all(be_a(CRM::Resources::TeachingEventBuildingResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::TeachingEventBuildingResource.new(
          id: "3290fb7f-93b4-eb11-8236-000d3a26ba1b",
          venue: "The Open University in Wales",
          address_line1: "Custom House Street",
          address_line2: nil,
          address_line3: nil,
          address_city: "Cardiff",
          address_postcode: "CF10 1AP",
          image_url: nil,
        )
      )
    end
  end

  describe "#teacher_training_adviser" do
    it "returns a GIT TeacherTrainingAdviser::Resource" do
      expect(adapter.teacher_training_adviser)
        .to be_a(CRM::Adapters::GetIntoTeaching::Resources::TeacherTrainingAdviser::Resource)
    end
  end

  describe "#candidates" do
    it "returns a GIT CandidatesResource" do
      expect(adapter.candidates)
        .to be_a(CRM::Adapters::GetIntoTeaching::Resources::CandidatesResource)
    end
  end

  describe "#get_into_teaching" do
    it "returns a GIT GetIntoTeachingResource" do
      expect(adapter.get_into_teaching)
        .to be_a(CRM::Adapters::GetIntoTeaching::Resources::GetIntoTeachingResource)
    end
  end

  describe "#schools_experience" do
    it "returns a GIT SchoolsExperienceResource" do
      expect(adapter.schools_experience)
        .to be_a(CRM::Adapters::GetIntoTeaching::Resources::SchoolsExperienceResource)
    end
  end

  describe "#operations" do
    it "returns a GIT OperationResource" do
      expect(adapter.operations)
        .to be_a(CRM::Adapters::GetIntoTeaching::Resources::OperationResource)
    end
  end

  describe "#teaching_events" do
    it "returns a GIT TeachingEventsResource" do
      expect(adapter.teaching_events)
        .to be_a(CRM::Adapters::GetIntoTeaching::Resources::TeachingEventsResource)
    end
  end

  describe "#privacy_policies", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/privacy_policies" } do
    subject(:result) { adapter.privacy_policies.find("4872c8ed-0229-f111-8342-7c1e5285e3ab") }

    it "returns PrivacyPolicyResource instance" do
      expect(result).to be_a(CRM::Resources::PrivacyPolicyResource)
    end

    it "deserializes the entry correctly" do
      expect(result).to eq(
        CRM::Resources::PrivacyPolicyResource.new(
          id: "4872c8ed-0229-f111-8342-7c1e5285e3ab",
          text: deserialized_test_text,
          created_at: "2026-03-26T11:00:01",
        )
      )
    end
  end

  private

  def deserialized_test_text
    text = <<~TEXT
<p><h2>Privacy notice for Get Into Teaching</h2></p>\n    <p>Last updated: 26 March 2026</p>\n    <p>Date of next review: April 2026</p>\n    <p>We might make changes before the review date. Check regularly for updates.</p>\n    <p>This privacy notice explains how the Department for Education (DfE) uses personal information in the Get Into Teaching service. This includes information you give to us, or information that we may collect about you.</p>\n    <p>Get Into Teaching is a project aimed at helping individuals get Into teaching giving support and guidance via the help portals mentioned below.</p>\n    <p>To access our adviser service, you need to be 18 years old or older. To access our personalised emails and events services, you need to be 16 years old or older.</p>\n    <p><h3>We've created a service that lets you:</h3></p>\n    <ul>\n        <li><p><a href=\"#getanadviser\">Get an adviser</a></p></li>\n        <li><p><a href=\"#schoolexperience\">Get school experience</a></p></li>\n        <li><p><a href=\"#manageschoolexperience\">Manage school experience</a></p></li>\n        <li><p><a href=\"#signupforemails\">Sign up for personalised emails</a></p></li>\n        <li><p><a href=\"#talktoanagentviawebchat\">Talk to an agent via webchat </a></p></li>\n    </ul>\n    <p>When you provide us with your personal data, we process it and provide you with tailored advice and information about teacher training, teaching as a career and events and school experience. These services will help you to make an informed decision about becoming a teacher or returning to teaching.</p>\n    <p>We may also contact you to gauge your interest in taking part in market research. In each message, you will be given the opportunity to unsubscribe from further communications.</p>\n\n<p>We will use anonymised and hashed data about you to deliver tailored messages on third party platforms, including social media - like Pinterest, Facebook, Instagram, X (formerly known as Twitter), Snapchat, YouTube and Google. Such data will be used for measurement to help us improve the accuracy of our marketing, and targeting and finding people like you, who may also be interested in our service. We do not allow these providers to share this data with others.</p>\n\n    <p><h3>Purpose and lawful basis for processing</h3></p>\n    <p>The DfE is the data controller for your personal data. We must have a reason to collect your personal data. This is called a 'lawful basis'.</p>\n    <p>We use the following lawful basis to process your personal data:</p>\n    <ul>\n        <li><p>Article 6 (1) (e) - public task – this is when we need your personal data to provide or fund education.</p></li>\n        <li><p>Article 6 (1) (f) - legitimate interest – where processing your personal data is necessary for a legitimate interest of DfE or a third party.</p></li> \n        <li><p>Article 6(1)(a) - Consent – this is when we process your personal data with your consent to provide targeted advertisements via the use of website tracking tools.</p></li>\n    </ul>\n    <p><h3>What we need</h3></p>\n    <p>We will collect the following types of personal information, some of which may be special category data, directly from you:</p>\n    <ul>\n        <li><p>first name</p></li>\n        <li><p>last name</p></li>\n        <li><p>date of birth</p></li>\n        <li><p>postcode</p></li>\n        <li><p>telephone number</p></li>\n        <li><p>email address</p></li>\n        <li><p>teacher reference number</p></li>\n        <li><p>subjects you are interested in teaching (maximum 2 choices)</p></li>\n        <li><p>the year you intend to start teacher training</p></li>\n        <li><p>stage you are at with degree study</p></li>\n        <li><p>the region you intend to do your Initial Teacher Training</p></li>\n        <li><p>IP Address</p></li>\n        <li><p>communications between the adviser/call agents and you (free text)</p></li>\n        <li><p>your qualifications</p></li>\n        <li><p>school experience you have undertaken</p></li>\n        <li><p>languages you can speak and/or teach</p></li>\n        <li><p>ITT providers you’ve applied to</p></li>\n        <li><p>barriers or concerns you have that may prevent you from starting an ITT course</p></li>\n        <li><p>your previous work experience/career history</p></li>\n    </ul>\n    <p>The types of data we collect for each service can be found in the corresponding privacy notices linked below:</p>\n    <ul>\n        <li><p><a href=\"#getanadviser\">Get an adviser</a></p></li>\n        <li><p><a href=\"#events\">Sign up to an event</a></p></li>\n        <li><p><a href=\"#schoolexperience\">Get school experience</a></p></li>\n        <li><p><a href=\"#manageschoolexperience\">Manage school experience</a></p></li>\n        <li><p><a href=\"#signupforemails\">Sign up for personalised emails</a></p></li>\n        <li><p><a href=\"#talktoanagentviawebchat\">Talk to an agent via webchat </a></p></li>\n    </ul>\n    <p><h3>Why we need it and what we do with it</h3></p>\n    <p>We collect and process your personal information to:</p>\n    <ul>\n        <li><p>enable us to provide the service to which you have chosen to access</p></li>\n        <li><p>analyse usage to enable us to make improvements to our service(s)</p></li>\n    </ul>\n    <p>If you use other digital services for which the Data Controller is also the Department for Education (for example, Apply for Postgraduate Teacher Training, or other Get Into Teaching services), we may use your data to understand how you are using these services. This allows us to ensure that public funds are being spent effectively.</p>\n    <p><h3>How long we keep it</h3></p>\n    <p>The Get Into Teaching Team will only keep your personal data for as long as we need it. We base this on the needs of the department and the law. Any information shared as part of a webchat will be kept for 6 months. Information shared as part of other Get Into Teaching services may be kept for up to 7 years but we will delete it, if you request us to do so.If it takes you more than 7 years to become a teacher, we may keep your personal data for up to 3 years after you stop using Get Into Teaching services. We do this to help support your career. </p>\n   <p>Any information shared during a webchat will be retained for 6 months. All calls to the adviser service are recorded for training and quality assurance purposes and stored for up to 12 months.  </p>\n <p>We will take necessary steps to keep your information safe. It will then be securely destroyed when it is no longer needed.</p>\n    <p><h3>Do we use any data processors?</h3></p>\n    <p>A data processor is an organisation that processes your information on DfE's behalf.</p>\n    <p>If we share your data, the DfE and the processor are independently accountable under the UK GDPR and Data Protection Act 2018 for your data. Each is responsible for complying with data protection legislation, including retention in accordance with their own statement.</p>\n    <p>We only use data processors for these activities:</p>\n    <ul>\n        <li><p>We have appointed TPUK to process personal data in the role of Advisers and Call Agents. They will process the following data when providing the Get Into Teaching Service</p></li>\n        <li><p>communications between the TPUK adviser/call agents and you (free text)</p></li>\n        <li><p>your qualifications</p></li>\n        <li><p>the type of ITT course you're interested in</p></li>\n        <li><p>school experience you've undertaken</p></li>\n        <li><p>languages you can speak and/or teach</p></li>\n        <li><p>barriers or concerns you have that may prevent you from starting an ITT course</p></li>\n        <li><p>your previous work experience/career history</p></li>\n    </ul>\n    <p><h3>Do we transfer data overseas?</h3></p>\n    <p>When DfE stores personal data outside the UK, we will make sure we keep your personal data safe. We follow the data protection law. We also use extra security measures, contracts and data sharing agreements.</p>\n    <p><h3>Do we share your personal information?</h3></p>\n    <p>If the law allows it, we might share your personal information with other parts of DfE including the Education and Skills Funding Agency (ESFA).</p>\n    <p>The <a href=\"https://www.gov.uk/government/publications/privacy-information-education-providers-workforce-including-teachers\">DfE's Privacy information for education providers’ workforce, including teachers</a> gives you more information on how we use your personal information.</p>\n    <p><h3>What are your rights?</h3></p>\n    <p>Under data protection law, you have rights including:</p>\n    <ul>\n        <li><p>Your right of access - You have the right to ask us for copies of your personal information</p></li>\n        <li><p>Your right to rectification - you can ask us to change any information you think is not accurate or complete</p></li>\n        <li><p>Your right to erasure - You have the right to ask us to delete your personal information</p></li>\n        <li><p>Your right to restriction of processing - You can ask us to stop processing your information</p></li>\n        <li><p>Your right to object to processing - You can object to the processing of your information</p></li>\n        <li><p>Your right to data portability - You can ask us to transfer your information to another organisation or to you</p></li>\n    </ul>\n    <p>For more information on your rights, please see the ICO (Information Commissioner’s Office) website.</p>\n    <p><h3>How to contact us or make a complaint</h3></p>\n    <p>If you have a question, or feel your data has been mishandled, you can contact us by:</p>\n    <p>using our secure <a href=\"https://form.education.gov.uk/service/Contact_the_Department_for_Education\">DfE Contact form</a></p>\n    <p>or writing to:</p>\n    <p><br>Data Protection Officer<br>Department for Education <br>4th floor<br>2 St Paul’s Place<br>125 Norfolk Street<br>Sheffield<br>S1 2FJ</p>\n    <p>You can also complain to the ICO by writing to:</p>\n    <p>Information Commissioner's Office<br>Water Lane<br>Wilmslow<br>Cheshire<br>SK9 5AF<br>Helpline number: 0303 123 1113.<br>Or use the online <a href=\"https://ico.org.uk/global/contact-us/email/\">ICO Contact form</a></p>\n    <p><h3>How to make a subject access request (SAR)</h3></p>\n    <p>You have the right to ask for access to your personal information, known as a subject access request (SAR).</p>\n    <p>Use the contact form or address above to make a SAR.</p>\n    <p>Include as much information as you can about the information you need. Include the years you need the information for. If possible, tell us which part of the department holds the information. You'll also need to tell us your telephone number and address.</p>\n    <p>We may need to check your identity and your right to access the information you're requesting. To check your identity, we may ask for a copy of your passport, photo driving licence or proof of your address.</p>\n    <p>We'll try to respond to your request within 1 month. But, if your request is complex, we may extend the period by a further 2 months, but we'll tell you if this is the case.</p>\n    <p><h2 id=\"getanadviser\">Get an adviser</h2></p>\n    <p><h3>The nature of your personal data we will be using</h3></p>\n    <p>The categories of your personal data that we will be using for this project are:</p>\n    <ul>\n        <li><p>your full name</p></li>\n        <li><p>contact details e.g. email address, postcode, telephone number, country of residence </p></li>\n        <li><p>date of birth</p></li>\n        <li><p>IP address</p></li>\n        <li><p>teacher reference number (TRN) if you have one</p></li>\n    </ul>\n    <p>Other details we will collect are:</p>\n    <ul>\n        <li><p>teaching subject</p></li>\n        <li><p>teaching stage</p></li>\n        <li><p>preferred teaching subjects</p></li>\n        <li><p>qualifications e.g. degree subject, stage, class</p></li>\n        <li><p>intended training commencement year</p></li>\n        <li><p>preferred call back date and time</p></li>\n    </ul>\n    <p><h3>What we do with your personal data when you sign up for an adviser</h3></p>\n    <p>The information you provide in the get an adviser form will be shared with our advisers, who will communicate with you via email and SMS, WhatsApp and by telephone calls to provide you with the support that you need. All calls are recorded for training and quality purposes. All recordings will be stored for up to 12 months before they are deleted. </p>\n    <p>We may also contact you by SMS, email or telephone call to inform you about services available to support you into teaching or important updates regarding teacher training.</p>\n    <p>If you have an equivalent qualification from outside the UK, your details will be shared with the Get Into Teaching helpline who will contact you to ensure they have accurate data about your circumstances in order to provide a tailored service and information to you. Any subsequent information you provide to the Get Into Teaching helpline will also be retained to enable us to continue to provide the support you require.</p>\n    <p>Where we are processing your personal data with your consent, you have the right to withdraw that consent. If you change your mind, or you are unhappy with our use of your personal data, please let us know by <a href=\"https://www.gov.uk/contact-dfe\">contacting the Department for Education</a> and state the name of this project.</p>\n\n<p><h2 id=\"events\">Sign up to an event</h2></p>\n\n<p>The Department for Education will no longer be running Get Into Teaching events from March 2026. </p>\n<p>If you signed up for a Get Into Teaching event prior to March 2026, we may still have the data you submitted, as we retain data for seven years in line with our data retention policy.  </p>\n<p>Where we are processing your personal data with your consent, you have the right to withdraw that consent. If you change your mind, or you are unhappy with our use of your personal data, please let us know by <a href=\"https://www.gov.uk/contact-dfe\"> contacting the Department for Education </a>  and state the name of this project.  </p>\n<p>The Get Into Teaching website promotes events run by other organisations. We do not have any control or oversight over how third party organisations manage your data.  </p>\n\n    <p><h2 id=\"schoolexperience\">Get school experience</h2></p>\n    <p><h3>The nature of your personal data we will be using</h3></p>\n    <p>The categories of your personal data that we will be using for this project are:</p>\n    <ul>\n        <li><p>your full name</p></li>\n        <li><p>contact details e.g. email address, postcode, telephone number</p></li>\n        <li><p>IP Address</p></li>\n    </ul>\n    <p>Other details we will collect are:</p>\n    <ul>\n        <li><p>qualifications e.g. subject, stage.</p></li>\n        <li><p>teaching subject, first choice and second choice</p></li>\n        <li><p>level of consideration in teaching </p></li>\n        <li><p>availability for school experience </p></li>\n        <li><p>reasons for wanting to undertake school experience </p></li>\n    </ul>\n    <p><h3>What we do with your personal data when you sign up for Get school experience</h3></p>\n    <ul>\n        <li><p>The information we collect from you, your name, contact details and preferences, is used for identification, administration, analysis and targeting purposes.</p></li>\n        <li><p>Any additional information you provide when you communicate with the helpline and /or advisers will help us to aid you in progressing your application and continue to improve our service. </p></li>\n        <li><p>We may also contact you to gauge your interest in taking part in market research. Each message will give you the opportunity to unsubscribe from further communications.</p></li>\n        <li><p>If you are using the Get school experience service, your data will be used to process your request for school experience with the school(s) in question. We will also use it to send out notifications, reminders and feedback questionnaires. We track your progress through this service to improve it for you and future applicants and to ensure public funds are being spent effectively.</p></li>\n        <li><p>We will use anonymised data about you to deliver tailored messages on third party platforms, including social media platforms, Pinterest, Facebook, Instagram, X (formerly known as Twitter), Snapchat,YouTube and Google. This anonymised data will also be used to identify and advertise to people that are similar to you, who may also be interested in our service.</p></li>\n        <li><p>We may also contact you by SMS or telephone call to inform you about services available to support you into teaching or important updates regarding teacher training.</p></li>\n    </ul>\n    <p>Where we are processing your personal data with your consent, you have the right to withdraw that consent. If you change your mind, or you are unhappy with our use of your personal data, please let us know by <a href=\"https://www.gov.uk/contact-dfe\">contacting the Department for Education</a> and state the name of this project.</p>\n    <p>We share data with each school you request experience with. Schools are data processors for the purposes of provision of this service. Each of the schools is required to comply with the UK GDPR and the DPA 2018 as data processors. Where we are processing your personal data with your consent, you have the right to withdraw that consent. If you change your mind, or you are unhappy with the school's use of your personal data, please contact the school directly.</p>\n\n\n\n    <p><h2 id=\"manageschoolexperience\">Manage school experience</h2></p>\n    <p><h3>The nature of your personal data we will be using </h3></p>\n    <p>To facilitate school experience, we collect the following details and data about school staff who manage the service when the school they work for or at signs up to the service:</p>\n    <ul>\n        <li><p>your full name</p></li>\n        <li><p>contact details e.g. email address, telephone number</p></li>\n        <li><p>IP address</p></li>\n    </ul>\n    <p><h3>What we do with your personal data when you Manage school experience</h3></p>\n    <ul>\n    <li><p>These details are shared with a candidate once their school experience request has been confirmed by the relevant school.</p></li>\n    <li><p>School staff can delete or update their contact details at any time in the service.</p></li>\n    <li><p>As part of the service, we'll use the contact information you've provided to send out notifications, reminders, feedback questionnaires and updates relating to the service. We may also contact you to request your involvement in user research to help improve the service.</p></li>\n    <li><p>We will also use collected data for security purposes to protect the service - for example, parts of the IP addresses of website visitors are collected to block continuous direct denial of service attacks from an IP address range.</p></li>\n   </ul>\n    <p>Where we are processing your personal data with your consent, you have the right to withdraw that consent. If you change your mind, or you are unhappy with our use of your personal data, please let us know by emailing us at <a href=\"mailto:organise.school-experience@education.gov.uk\">organise.school-experience@education.gov.uk </a>  or by <a href=\"https://www.gov.uk/contact-dfe\">contacting the Department for Education</a> and state the name of this project.</p>\n\n <p><h2 id=\"signupforemails\">Sign up for personalised emails</h2></p>\n    <p><h3>The nature of your personal data we will be using </h3></p>\n    <p>The categories of your personal data that we will be using for this project are:</p>\n    <ul>\n        <li><p>your full name</p></li>\n        <li><p>contact details e.g. email address, postcode, telephone number (optional)</p></li>\n        <li><p>IP address</p></li>\n    </ul>\n    <p>Other details we will collect are:</p>\n    <ul>\n        <li><p>degree stage</p></li>\n        <li><p>teaching subject</p></li>\n        <li><p>level of consideration in teaching </p></li>\n    </ul>\n    <p><h3>What we do with your personal data when you sign up for emails</h3></p>\n    <p>When you sign up for emails, the information you provide in the form will allow us to send you personalised emails containing tailored information about a career in teaching. </p>\n    <p>We may also contact you by SMS or telephone call to inform you about services available to support you into teaching or important updates regarding teacher training.</p>\n    <p>Where we are processing your personal data with your consent, you have the right to withdraw that consent. If you change your mind, or you are unhappy with our use of your personal data, please let us know by <a href=\"https://www.gov.uk/contact-dfe\">contacting the Department for Education</a> and state the name of this project.</p>\n    <p><h2 id=\"talktoanagentviawebchat\">Talk to an agent via webchat</h2></p>\n    <p><h3>The nature of your personal data we will be using </h3></p>\n    <p>The categories of your personal data that we will be using for this project are:</p>\n    <ul>\n        <li><p>your name</p></li>\n        <li><p>IP address</p></li>\n         <li><p>anything you choose to share with us when using the webchat service, this includes any documents you upload to the chat</p></li>\n       </ul>\n    <p><h3>What we do with your personal data when you contact one of our Get Into Teaching Agents </h3></p>\n    <p>The information you provide in the webchat will be used by our Get Into Teaching Agents to provide you with a transcript of the chat if you request one. We will also use it to identify you if you contact the service again for further assistance.</p>\n    <p>Any information you choose to provide to the Get Into Teaching Agents may be retained to enable us to continue to provide the support you require.</p>\n    <p>Where we are processing your personal data with your consent, you have the right to withdraw that consent. If you change your mind, or you are unhappy with our use of your personal data, please let us know by <a href=\"https://www.gov.uk/contact-dfe\">contacting the Department for Education</a> and state the name of this project.</p>
    TEXT
    text.chomp
  end
end
