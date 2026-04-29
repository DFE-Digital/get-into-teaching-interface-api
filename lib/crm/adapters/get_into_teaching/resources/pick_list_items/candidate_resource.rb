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
          end
        end
      end
    end
  end
end
