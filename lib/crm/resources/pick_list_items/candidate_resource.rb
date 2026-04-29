module CRM
  module Resources
    module PickListItems
      class CandidateResource
        def initial_teacher_training_years(*) = raise NotImplementedError

        def preferred_education_phases(*) = raise NotImplementedError
      end
    end
  end
end
