module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module Qualification
            class TypesResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/qualification/types", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::Qualification::TypeResource)
              end
            end
          end
        end
      end
    end
  end
end
