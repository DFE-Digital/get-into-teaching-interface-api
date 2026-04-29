module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module Candidate
            class MailingListSubscriptionChannelsResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/candidate/mailing_list_subscription_channels", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::Candidate::MailingListSubscriptionChannelResource)
              end
            end
          end
        end
      end
    end
  end
end
