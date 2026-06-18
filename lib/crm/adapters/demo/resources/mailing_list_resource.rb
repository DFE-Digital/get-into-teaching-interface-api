module CRM
  module Adapters
    module Demo
      module Resources
        class MailingListResource
          def create_member(_body)
            Data.define(:body).new(body: { "degreeStatusId" => 222750000 })
          end

          def exchange_access_token(_token, _body)
            Data.define(:body).new(body: ExchangeTokenResponse::BODY)
          end
        end
      end
    end
  end
end
