module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module Candidate
            class AdviserEligibilitiesResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/candidate/adviser_eligibilities", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::Candidate::AdviserEligibilityResource)
              end
            end
          end
        end
      end
    end
  end
end
