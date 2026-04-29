module CRM
  module Adapters
    module Demo
      module Resources
        module PickListItems
          class ServiceSubscriptionResource < CRM::Resources::PickListItems::ServiceSubscriptionResource
            def types
              ServiceSubscription::TypesResource.new
            end
          end
        end
      end
    end
  end
end
