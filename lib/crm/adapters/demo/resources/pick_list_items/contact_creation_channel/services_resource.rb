module CRM
  module Adapters
    module Demo
      module Resources
        module PickListItems
          module ContactCreationChannel
            class ServicesResource < CRM::Resources::PickListItems::ContactCreationChannel::ServicesResource
              def all(*)
                [
                  CRM::Resources::PickListItems::ContactCreationChannel::ServiceResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", value: "Example 1"),
                  CRM::Resources::PickListItems::ContactCreationChannel::ServiceResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa7", value: "Example 2"),
                ]
              end
            end
          end
        end
      end
    end
  end
end
