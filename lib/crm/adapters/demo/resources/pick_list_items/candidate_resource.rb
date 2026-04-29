module CRM
  module Adapters
    module Demo
      module Resources
        module PickListItems
          class CandidateResource < CRM::Resources::PickListItems::CandidateResource
            def initial_teacher_training_years
              Candidate::InitialTeacherTrainingYearsResource.new
            end

            def preferred_education_phases
              Candidate::PreferredEducationPhasesResource.new
            end

            def channels
              Candidate::ChannelsResource.new
            end

            def mailing_list_subscription_channels
              Candidate::MailingListSubscriptionChannelsResource.new
            end

            def event_subscription_channels
              Candidate::EventSubscriptionChannelsResource.new
            end

            def teacher_training_adviser_subscription_channels
              Candidate::TeacherTrainingAdviserSubscriptionChannelsResource.new
            end

            def gcse_statuses
              Candidate::GcseStatusesResource.new
            end

            def retake_gcse_statuses
              Candidate::RetakeGcseStatusesResource.new
            end

            def consideration_journey_stages
              Candidate::ConsiderationJourneyStagesResource.new
            end

            def adviser_eligibilities
              Candidate::AdviserEligibilitiesResource.new
            end

            def adviser_requirements
              Candidate::AdviserRequirementsResource.new
            end

            def types
              Candidate::TypesResource.new
            end

            def assignment_statuses
              Candidate::AssignmentStatusesResource.new
            end

            def situations
              Candidate::SituationsResource.new
            end

            def citizenships
              Candidate::CitizenshipsResource.new
            end

            def visa_statuses
              Candidate::VisaStatusesResource.new
            end

            def locations
              Candidate::LocationsResource.new
            end

            def has_qualified_teacher_statuses
              Candidate::HasQualifiedTeacherStatusesResource.new
            end
          end
        end
      end
    end
  end
end
