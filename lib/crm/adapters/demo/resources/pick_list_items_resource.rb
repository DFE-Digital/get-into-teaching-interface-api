module CRM
  module Adapters
    module Demo
      module Resources
        class PickListItemsResource < CRM::Resources::PickListItemsResource
          def candidate
            PickListItems::CandidateResource.new
          end
        end
      end
    end
  end
end
