module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module Candidate
            class CitizenshipsResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/candidate/citizenships", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::Candidate::CitizenshipResource)
              end
            end
          end
        end
      end
    end
  end
end
