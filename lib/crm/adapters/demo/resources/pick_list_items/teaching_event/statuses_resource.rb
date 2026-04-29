module CRM
  module Adapters
    module Demo
      module Resources
        module PickListItems
          module TeachingEvent
            class StatusesResource < CRM::Resources::PickListItems::TeachingEvent::StatusesResource
              def all(*)
                [
                  CRM::Resources::PickListItems::TeachingEvent::StatusResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", value: "Example 1"),
                  CRM::Resources::PickListItems::TeachingEvent::StatusResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa7", value: "Example 2"),
                ]
              end
            end
          end
        end
      end
    end
  end
end
