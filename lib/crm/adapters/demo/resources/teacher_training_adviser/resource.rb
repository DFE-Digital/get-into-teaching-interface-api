module CRM
  module Adapters
    module Demo
      module Resources
        module TeacherTrainingAdviser
          class Resource
            def create_candidate(_body)
              Data.define(:body).new(body: { "degreeStatusId" => 222750000 })
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
end
