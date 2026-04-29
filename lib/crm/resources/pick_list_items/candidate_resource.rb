module CRM
  module Resources
    module PickListItems
      class CandidateResource
        def initial_teacher_training_years(*) = raise NotImplementedError

        def preferred_education_phases(*) = raise NotImplementedError

        def channels(*) = raise NotImplementedError

        def mailing_list_subscription_channels(*) = raise NotImplementedError

        def event_subscription_channels(*) = raise NotImplementedError

        def teacher_training_adviser_subscription_channels(*) = raise NotImplementedError
      end
    end
  end
end
