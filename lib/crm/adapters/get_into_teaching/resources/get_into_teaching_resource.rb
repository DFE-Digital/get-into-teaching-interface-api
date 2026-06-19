module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class GetIntoTeachingResource < CRM::Adapters::GetIntoTeaching::Resource
          def create_callback(body)
            post_request("/api/get_into_teaching/callbacks", body:)
          end
        end
      end
    end
  end
end
