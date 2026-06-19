module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class GetIntoTeachingResource < CRM::Adapters::GetIntoTeaching::Resource
          def create_callback(body)
            post_request("/api/get_into_teaching/callbacks", body:)
          end

          def matchback(body)
            post_request("/api/get_into_teaching/callbacks/matchback", body:)
          end

          def exchange_access_token(token, body)
            post_request("/api/get_into_teaching/callbacks/exchange_access_token/#{token}", body:)
          end
        end
      end
    end
  end
end
