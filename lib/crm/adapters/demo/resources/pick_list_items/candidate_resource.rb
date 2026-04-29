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
          end
        end
      end
    end
  end
end
