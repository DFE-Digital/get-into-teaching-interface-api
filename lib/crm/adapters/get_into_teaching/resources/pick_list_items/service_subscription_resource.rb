module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          class ServiceSubscriptionResource < CRM::Resources::PickListItems::ServiceSubscriptionResource
            def initialize(client)
              @client = client
            end

            def types = ServiceSubscription::TypesResource.new(@client)
          end
        end
      end
    end
  end
end
