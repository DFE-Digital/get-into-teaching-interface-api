module CRM
  module Resources
    module PickListItems
      class ContactCreationChannelResource
        def sources(*) = raise NotImplementedError

        def services(*) = raise NotImplementedError
      end
    end
  end
end
