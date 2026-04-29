module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module Qualification
            class UkDegreeGradesResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/qualification/uk_degree_grades", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::Qualification::UkDegreeGradeResource)
              end
            end
          end
        end
      end
    end
  end
end
