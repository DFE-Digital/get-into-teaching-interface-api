module CRM
  module Resources
    module PickListItems
      module Candidate
        class ChannelsResource
          # @return [Array<CRM::Resources::PickListItems::Candidate::ChannelResource]
          def all(*)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
