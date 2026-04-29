module CRM
  module Adapters
    module Demo
      module Resources
        module PickListItems
          class TeachingEventResource < CRM::Resources::PickListItems::TeachingEventResource
            def types
              TeachingEvent::TypesResource.new
            end

            def regions
              TeachingEvent::RegionsResource.new
            end

            def statuses
              TeachingEvent::StatusesResource.new
            end
          end
        end
      end
    end
  end
end
