module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module Candidate
            class VisaStatusesResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/candidate/visa_statuses", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::Candidate::VisaStatusResource)
              end
            end
          end
        end
      end
    end
  end
end
