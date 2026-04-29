module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          class ContactCreationChannelResource < CRM::Resources::PickListItems::ContactCreationChannelResource
            def initialize(client)
              @client = client
            end

            def sources = ContactCreationChannel::SourcesResource.new(@client)

            def services = ContactCreationChannel::ServicesResource.new(@client)
          end
        end
      end
    end
  end
end
