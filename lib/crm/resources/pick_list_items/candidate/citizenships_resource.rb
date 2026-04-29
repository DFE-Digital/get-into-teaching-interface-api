module CRM
  module Resources
    module PickListItems
      module Candidate
        class CitizenshipsResource
          # @return [Array<CRM::Resources::PickListItems::Candidate::CitizenshipResource]
          def all(*)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
