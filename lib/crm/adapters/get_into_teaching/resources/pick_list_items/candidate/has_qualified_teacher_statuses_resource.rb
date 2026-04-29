module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module Candidate
            class HasQualifiedTeacherStatusesResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/candidate/has_qualified_teacher_statuses", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::Candidate::HasQualifiedTeacherStatusResource)
              end
            end
          end
        end
      end
    end
  end
end
