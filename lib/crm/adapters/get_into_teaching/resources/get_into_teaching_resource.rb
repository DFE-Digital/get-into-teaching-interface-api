module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class GetIntoTeachingResource < CRM::Adapters::GetIntoTeaching::Resource
          def create_callback(body)
            post_request("/api/get_into_teaching/callbacks", body:)
          end

          def matchback(body)
            response = post_request("/api/get_into_teaching/callbacks/matchback", body:)
            response_to_type(response, type: CRM::Resources::GetIntoTeaching::CandidateResource)
          end

          def exchange_access_token(token, body)
            response = post_request("/api/get_into_teaching/callbacks/exchange_access_token/#{token}", body:)
            response_to_type(response, type: CRM::Resources::GetIntoTeaching::CandidateResource)
          end
        end
      end
    end
  end
end
