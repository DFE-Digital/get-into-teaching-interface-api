module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module Candidate
            class AssignmentStatusesResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/candidate/assignment_status", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::Candidate::AssignmentStatusResource)
              end
            end
          end
        end
      end
    end
  end
end
