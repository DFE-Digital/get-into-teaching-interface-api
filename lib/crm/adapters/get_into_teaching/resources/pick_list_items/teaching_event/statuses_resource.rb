module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module TeachingEvent
            class StatusesResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/teaching_event/status", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::TeachingEvent::StatusResource)
              end
            end
          end
        end
      end
    end
  end
end
