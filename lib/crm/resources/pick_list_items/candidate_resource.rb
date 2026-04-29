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

        def gcse_status(*) = raise NotImplementedError

        def gcse_statuses(*) = raise NotImplementedError

        def retake_gcse_statuses(*) = raise NotImplementedError

        def consideration_journey_stages(*) = raise NotImplementedError

        def adviser_eligibilities(*) = raise NotImplementedError

        def adviser_requirements(*) = raise NotImplementedError

        def types(*) = raise NotImplementedError

        def assignment_statuses(*) = raise NotImplementedError

        def situations(*) = raise NotImplementedError

        def citizenships(*) = raise NotImplementedError

        def visa_statuses(*) = raise NotImplementedError
      end
    end
  end
end
