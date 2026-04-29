module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module Candidate
            class ConsiderationJourneyStagesResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/candidate/consideration_journey_stages", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::Candidate::ConsiderationJourneyStageResource)
              end
            end
          end
        end
      end
    end
  end
end
