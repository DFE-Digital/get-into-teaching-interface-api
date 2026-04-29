module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          class CandidateResource < CRM::Resources::PickListItems::CandidateResource
            def initialize(client)
              @client = client
            end

            def initial_teacher_training_years = Candidate::InitialTeacherTrainingYearsResource.new(@client)

            def preferred_education_phases = Candidate::PreferredEducationPhasesResource.new(@client)

            def channels = Candidate::ChannelsResource.new(@client)

            def mailing_list_subscription_channels = Candidate::MailingListSubscriptionChannelsResource.new(@client)

            def event_subscription_channels = Candidate::EventSubscriptionChannelsResource.new(@client)

            def teacher_training_adviser_subscription_channels = Candidate::TeacherTrainingAdviserSubscriptionChannelsResource.new(@client)

            def gcse_statuses = Candidate::GcseStatusesResource.new(@client)

            def retake_gcse_statuses = Candidate::RetakeGcseStatusesResource.new(@client)

            def consideration_journey_stages = Candidate::ConsiderationJourneyStagesResource.new(@client)

            def adviser_eligibilities = Candidate::AdviserEligibilitiesResource.new(@client)

            def adviser_requirements = Candidate::AdviserRequirementsResource.new(@client)

            def types = Candidate::TypesResource.new(@client)

            def assignment_statuses = Candidate::AssignmentStatusesResource.new(@client)
          end
        end
      end
    end
  end
end
