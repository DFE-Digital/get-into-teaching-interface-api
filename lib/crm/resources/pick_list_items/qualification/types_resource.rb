module CRM
  module Resources
    module PickListItems
      module Qualification
        class TypesResource
          # @return [Array<CRM::Resources::PickListItems::Qualification::TypeResource]
          def all(*)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
