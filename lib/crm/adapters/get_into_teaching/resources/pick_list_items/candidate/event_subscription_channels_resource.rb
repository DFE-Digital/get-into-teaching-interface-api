module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module Candidate
            class EventSubscriptionChannelsResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/candidate/event_subscription_channels", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::Candidate::EventSubscriptionChannelResource)
              end
            end
          end
        end
      end
    end
  end
end
