module CRM
  module Resources
    module PickListItems
      class QualificationResource
        def degree_statuses(*) = raise NotImplementedError

        def types(*) = raise NotImplementedError

        def uk_degree_grades(*) = raise NotImplementedError
      end
    end
  end
end
