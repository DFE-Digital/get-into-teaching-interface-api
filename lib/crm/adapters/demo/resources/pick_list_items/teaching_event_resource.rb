module CRM
  module Adapters
    module Demo
      module Resources
        module PickListItems
          class TeachingEventResource < CRM::Resources::PickListItems::TeachingEventResource
            def types
              TeachingEvent::TypesResource.new
            end
          end
        end
      end
    end
  end
end
