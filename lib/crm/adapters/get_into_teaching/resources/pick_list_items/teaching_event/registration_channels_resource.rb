module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module TeachingEvent
            class RegistrationChannelsResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/teaching_event_registration/channels", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::TeachingEvent::RegistrationChannelResource)
              end
            end
          end
        end
      end
    end
  end
end
