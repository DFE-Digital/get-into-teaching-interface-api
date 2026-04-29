module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          class PhoneCallResource < CRM::Resources::PickListItems::PhoneCallResource
            def initialize(client)
              @client = client
            end

            def channels = PhoneCall::ChannelsResource.new(@client)
          end
        end
      end
    end
  end
end
