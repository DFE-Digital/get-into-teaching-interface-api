module CRM
  module Resources
    module PickListItems
      module Candidate
        class SituationsResource
          # @return [Array<CRM::Resources::PickListItems::Candidate::SituationResource]
          def all(*)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
