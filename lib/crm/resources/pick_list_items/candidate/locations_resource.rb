module CRM
  module Resources
    module PickListItems
      module Candidate
        class LocationsResource
          # @return [Array<CRM::Resources::PickListItems::Candidate::LocationResource]
          def all(*)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
