module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class GetIntoTeachingResource < CRM::Resources::GetIntoTeachingResource
          def initialize(client)
            @client = client
          end

          def callbacks = GetIntoTeaching::CallbacksResource.new(@client)
        end
      end
    end
  end
end
