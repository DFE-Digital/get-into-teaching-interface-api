module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module GetIntoTeaching
          class CallbacksResource < CRM::Adapters::GetIntoTeaching::Resource
            def create(body)
              post_request("/api/teacher_training_adviser/candidates", body:)
            end
          end
        end
      end
    end
  end
end
