module CRM
  module Adapters
    module Demo
      module Resources
        class GetIntoTeachingResource
          def create_callback(_body)
            true
          end

          def exchange_access_token(_token, _body)
            Data.define(:body).new(body: ExchangeTokenResponse::BODY)
          end

          def matchback(_body)
            Data.define(:body).new(body: ExchangeTokenResponse::BODY)
          end
        end
      end
    end
  end
end
