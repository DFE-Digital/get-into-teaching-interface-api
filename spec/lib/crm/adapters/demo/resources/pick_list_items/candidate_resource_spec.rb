require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::PickListItems::CandidateResource do
  subject(:resource) { described_class.new }

  describe "#initial_teacher_training_years" do
    it "returns a Demo PickListItems::Candidate::InitialTeacherTrainingYearsResource" do
      expect(resource.initial_teacher_training_years).to be_a(CRM::Adapters::Demo::Resources::PickListItems::Candidate::InitialTeacherTrainingYearsResource)
    end
  end

  describe "#preferred_education_phases" do
    it "returns a Demo PickListItems::Candidate::PreferredEducationPhasesResource" do
      expect(resource.preferred_education_phases).to be_a(CRM::Adapters::Demo::Resources::PickListItems::Candidate::PreferredEducationPhasesResource)
    end
  end

  describe "#channels" do
    it "returns a Demo PickListItems::Candidate::ChannelsResource" do
      expect(resource.channels).to be_a(CRM::Adapters::Demo::Resources::PickListItems::Candidate::ChannelsResource)
    end
  end

  describe "#mailing_list_subscription_channels" do
    it "returns a Demo PickListItems::Candidate::MailingListSubscriptionChannelsResource" do
      expect(resource.mailing_list_subscription_channels).to be_a(CRM::Adapters::Demo::Resources::PickListItems::Candidate::MailingListSubscriptionChannelsResource)
    end
  end

  describe "#event_subscription_channels" do
    it "returns a Demo PickListItems::Candidate::EventSubscriptionChannelsResource" do
      expect(resource.event_subscription_channels).to be_a(CRM::Adapters::Demo::Resources::PickListItems::Candidate::EventSubscriptionChannelsResource)
    end
  end

  describe "#teacher_training_adviser_subscription_channels" do
    it "returns a Demo PickListItems::Candidate::TeacherTrainingAdviserSubscriptionChannelsResource" do
      expect(resource.teacher_training_adviser_subscription_channels).to be_a(CRM::Adapters::Demo::Resources::PickListItems::Candidate::TeacherTrainingAdviserSubscriptionChannelsResource)
    end
  end

  describe "#gcse_statuses" do
    it "returns a Demo PickListItems::Candidate::GcseStatusesResource" do
      expect(resource.gcse_statuses).to be_a(CRM::Adapters::Demo::Resources::PickListItems::Candidate::GcseStatusesResource)
    end
  end

  describe "#retake_gcse_statuses" do
    it "returns a Demo PickListItems::Candidate::RetakeGcseStatusesResource" do
      expect(resource.retake_gcse_statuses).to be_a(CRM::Adapters::Demo::Resources::PickListItems::Candidate::RetakeGcseStatusesResource)
    end
  end

  describe "#consideration_journey_stages" do
    it "returns a Demo PickListItems::Candidate::ConsiderationJourneyStagesResource" do
      expect(resource.consideration_journey_stages).to be_a(CRM::Adapters::Demo::Resources::PickListItems::Candidate::ConsiderationJourneyStagesResource)
    end
  end

  describe "#adviser_eligibilities" do
    it "returns a Demo PickListItems::Candidate::AdviserEligibilitiesResource" do
      expect(resource.adviser_eligibilities).to be_a(CRM::Adapters::Demo::Resources::PickListItems::Candidate::AdviserEligibilitiesResource)
    end
  end

  describe "#adviser_requirements" do
    it "returns a Demo PickListItems::Candidate::AdviserRequirementsResource" do
      expect(resource.adviser_requirements).to be_a(CRM::Adapters::Demo::Resources::PickListItems::Candidate::AdviserRequirementsResource)
    end
  end

  describe "#types" do
    it "returns a Demo PickListItems::Candidate::TypesResource" do
      expect(resource.types).to be_a(CRM::Adapters::Demo::Resources::PickListItems::Candidate::TypesResource)
    end
  end
end
