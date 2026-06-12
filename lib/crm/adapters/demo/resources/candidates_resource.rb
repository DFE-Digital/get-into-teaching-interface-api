module CRM
  module Adapters
    module Demo
      module Resources
        class CandidatesResource
          def create_access_token(_body)
            true
          end
        end
      end
    end
  end
end
