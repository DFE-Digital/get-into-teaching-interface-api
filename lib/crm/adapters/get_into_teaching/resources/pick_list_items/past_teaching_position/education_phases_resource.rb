module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module PastTeachingPosition
            class EducationPhasesResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/past_teaching_position/education_phases", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::PastTeachingPosition::EducationPhaseResource)
              end
            end
          end
        end
      end
    end
  end
end
