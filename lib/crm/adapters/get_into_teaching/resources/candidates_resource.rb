module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class CandidatesResource < CRM::Adapters::GetIntoTeaching::Resource
          def create_access_token(body)
            post_request("/api/candidates/access_tokens", body:)
          end
        end
      end
    end
  end
end
