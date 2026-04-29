module CRM
  module Resources
    module PickListItems
      class PhoneCallResource
        def channels(*) = raise NotImplementedError
      end
    end
  end
end
