module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module ServiceSubscription
            class TypesResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/service_subscription/types", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::ServiceSubscription::TypeResource)
              end
            end
          end
        end
      end
    end
  end
end
