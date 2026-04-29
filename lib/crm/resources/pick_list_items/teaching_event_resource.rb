module CRM
  module Resources
    module PickListItems
      class TeachingEventResource
        def types(*) = raise NotImplementedError

        def regions(*) = raise NotImplementedError

        def statuses(*) = raise NotImplementedError

        def registration_channels(*) = raise NotImplementedError
      end
    end
  end
end
