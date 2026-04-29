module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          class TeachingEventResource < CRM::Resources::PickListItems::TeachingEventResource
            def initialize(client)
              @client = client
            end

            def types = TeachingEvent::TypesResource.new(@client)
          end
        end
      end
    end
  end
end
