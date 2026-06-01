module CRM
  module Adapters
    module Demo
      module Resources
        class GetIntoTeachingResource < CRM::Resources::GetIntoTeachingResource
          def callbacks
            GetIntoTeaching::CallbacksResource.new
          end
        end
      end
    end
  end
end
