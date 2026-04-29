module CRM
  module Resources
    module PickListItems
      module ContactCreationChannel
        class SourcesResource
          # @return [Array<CRM::Resources::PickListItems::ContactCreationChannel::SourceResource]
          def all(*)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
