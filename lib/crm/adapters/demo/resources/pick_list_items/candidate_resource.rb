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
          end
        end
      end
    end
  end
end
