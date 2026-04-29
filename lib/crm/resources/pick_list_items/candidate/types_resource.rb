module CRM
  module Resources
    module PickListItems
      module Candidate
        class TypesResource
          # @return [Array<CRM::Resources::PickListItems::Candidate::TypeResource]
          def all(*)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
