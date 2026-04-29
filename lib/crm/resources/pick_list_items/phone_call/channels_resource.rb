module CRM
  module Resources
    module PickListItems
      module PhoneCall
        class ChannelsResource
          # @return [Array<CRM::Resources::PickListItems::PhoneCall::ChannelResource]
          def all(*)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
