module CRM
  module Adapters
    module Demo
      module Resources
        module PickListItems
          class ContactCreationChannelResource < CRM::Resources::PickListItems::ContactCreationChannelResource
            def sources
              ContactCreationChannel::SourcesResource.new
            end

            def services
              ContactCreationChannel::ServicesResource.new
            end

            def activities
              ContactCreationChannel::ActivitiesResource.new
            end
          end
        end
      end
    end
  end
end
