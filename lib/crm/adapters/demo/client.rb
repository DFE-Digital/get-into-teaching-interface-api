module CRM
  module Adapters
    module Demo
      class Client
        def lookup_items
          Resources::LookUpItemsResource.new
        end

        def pick_list_items
          Resources::PickListItemsResource.new
        end
      end
    end
  end
end
