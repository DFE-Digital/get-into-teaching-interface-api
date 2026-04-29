module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          module Candidate
            class InitialTeacherTrainingYearsResource < CRM::Adapters::GetIntoTeaching::Resource
              def all(**params)
                response = get_request("/api/pick_list_items/candidate/initial_teacher_training_years", params: params)
                response_to_collection(response, type: CRM::Resources::PickListItems::Candidate::InitialTeacherTrainingYearResource)
              end
            end
          end
        end
      end
    end
  end
end
