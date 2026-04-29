module CRM
  module Adapters
    module Demo
      module Resources
        module PickListItems
          class PhoneCallResource < CRM::Resources::PickListItems::PhoneCallResource
            def channels
              PhoneCall::ChannelsResource.new
            end
          end
        end
      end
    end
  end
end
