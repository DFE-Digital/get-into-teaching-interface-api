module CRM
  module Adapters
    module Demo
      module Resources
        class TeachingEventBuildingsResource < CRM::Resources::TeachingEventBuildingsResource
          def all(*)
            [
              CRM::Resources::TeachingEventBuildingResource.new(
                venue: "The Open University in Wales",
                address_line1: "Custom House Street",
                address_line2: nil,
                address_line3: nil,
                address_city: "Cardiff",
                address_postcode: "CF10 1AP",
                image_url: nil,
                id: "3290fb7f-93b4-eb11-8236-000d3a26ba1b"
              ),
              CRM::Resources::TeachingEventBuildingResource.new(
                venue: "World Trade Centre -Delhi",
                address_line1: "1",
                address_line2: "2",
                address_line3: "3",
                address_city: "Delhi",
                address_postcode: "se28 8pt",
                image_url: nil,
                id: "3ef13d86-9b62-ee11-8df0-6045bd8c543c"
              ),
            ]
          end
        end
      end
    end
  end
end
