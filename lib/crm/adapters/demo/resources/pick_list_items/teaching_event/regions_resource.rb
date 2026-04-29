module CRM
  module Adapters
    module Demo
      module Resources
        module PickListItems
          module TeachingEvent
            class RegionsResource < CRM::Resources::PickListItems::TeachingEvent::RegionsResource
              def all(*)
                [
                  CRM::Resources::PickListItems::TeachingEvent::RegionResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", value: "Example 1"),
                  CRM::Resources::PickListItems::TeachingEvent::RegionResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa7", value: "Example 2"),
                ]
              end
            end
          end
        end
      end
    end
  end
end
