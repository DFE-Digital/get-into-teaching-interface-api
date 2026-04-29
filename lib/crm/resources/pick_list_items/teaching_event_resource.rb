module CRM
  module Resources
    module PickListItems
      class TeachingEventResource
        def types(*) = raise NotImplementedError

        def regions(*) = raise NotImplementedError
      end
    end
  end
end
