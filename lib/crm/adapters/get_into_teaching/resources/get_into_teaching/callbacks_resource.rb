module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module GetIntoTeaching
          class CallbacksResource < CRM::Adapters::GetIntoTeaching::Resource
            def create(**body)
              response = post_request("/api/get_into_teaching/callbacks", body: body)
              response_to_type(response, type: CRM::Resources::GetIntoTeaching::CallbackResource)
            end
          end
        end
      end
    end
  end
end
