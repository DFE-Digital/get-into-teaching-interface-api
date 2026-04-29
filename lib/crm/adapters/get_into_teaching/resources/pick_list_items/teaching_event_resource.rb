module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          class TeachingEventResource < CRM::Resources::PickListItems::TeachingEventResource
            def initialize(client)
              @client = client
            end

            def types = TeachingEvent::TypesResource.new(@client)

            def regions = TeachingEvent::RegionsResource.new(@client)

            def statuses = TeachingEvent::StatusesResource.new(@client)

            def registration_channels = TeachingEvent::RegistrationChannelsResource.new(@client)

            def accessibility_items = TeachingEvent::AccessibilityItemsResource.new(@client)
          end
        end
      end
    end
  end
end
