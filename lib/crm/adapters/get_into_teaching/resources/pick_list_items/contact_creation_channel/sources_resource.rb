module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module ContactCreationChannel
            class SourcesResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/contact_creation_channel/sources", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::ContactCreationChannel::SourceResource)
              end
            end
          end
        end
      end
    end
  end
end
