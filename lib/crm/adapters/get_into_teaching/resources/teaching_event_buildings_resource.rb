module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class TeachingEventBuildingsResource < CRM::Adapters::GetIntoTeaching::Resource
          def all(**params)
            response = get_request("/api/teaching_event_buildings", params: params)
            response_to_collection(response, type: CRM::Resources::TeachingEvents::BuildingResource)
          end
        end
      end
    end
  end
end
