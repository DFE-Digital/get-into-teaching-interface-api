module CRM
  module Adapters
    module Demo
      module Resources
        class PickListItemsResource < CRM::Resources::PickListItemsResource
          def candidate
            PickListItems::CandidateResource.new
          end

          def qualification
            PickListItems::QualificationResource.new
          end
        end
      end
    end
  end
end
