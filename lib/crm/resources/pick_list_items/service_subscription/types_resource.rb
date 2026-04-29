module CRM
  module Resources
    module PickListItems
      module ServiceSubscription
        class TypesResource
          # @return [Array<CRM::Resources::PickListItems::ServiceSubscription::TypeResource]
          def all(*)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
