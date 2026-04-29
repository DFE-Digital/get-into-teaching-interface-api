module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module Candidate
            class PreferredEducationPhasesResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/candidate/preferred_education_phases", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::Candidate::PreferredEducationPhaseResource)
              end
            end
          end
        end
      end
    end
  end
end
