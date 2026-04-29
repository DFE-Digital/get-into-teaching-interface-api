module CRM
  module Resources
    module PickListItems
      module ContactCreationChannel
        class ServicesResource
          # @return [Array<CRM::Resources::PickListItems::ContactCreationChannel::ServiceResource]
          def all(*)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
