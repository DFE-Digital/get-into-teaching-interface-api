module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module PhoneCall
            class ChannelsResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/phone_call/channels", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::PhoneCall::ChannelResource)
              end
            end
          end
        end
      end
    end
  end
end
