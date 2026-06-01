module CRM
  module Adapters
    module Demo
      module Resources
        module GetIntoTeaching
          class CallbacksResource < CRM::Resources::GetIntoTeaching::CallbacksResource
            def create(**body)
              CRM::Resources::GetIntoTeaching::CallbackResource.new(
                id: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
                value: "Example 1",
              )
            end
          end
        end
      end
    end
  end
end
