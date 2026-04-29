module CRM
  module Resources
    module PickListItems
      module ContactCreationChannel
        class ActivitiesResource
          # @return [Array<CRM::Resources::PickListItems::ContactCreationChannel::ActivityResource]
          def all(*)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
