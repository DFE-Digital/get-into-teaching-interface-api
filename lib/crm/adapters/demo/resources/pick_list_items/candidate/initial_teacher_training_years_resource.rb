# frozen_string_literal: true

module CRM
  module Adapters
    module Demo
      module Resources
        module PickListItems
          module Candidate
            class InitialTeacherTrainingYearsResource < CRM::Resources::PickListItems::Candidate::InitialTeacherTrainingYearsResource
              def all(*)
                [
                  CRM::Resources::PickListItems::Candidate::InitialTeacherTrainingYearResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", value: "Example 1"),
                  CRM::Resources::PickListItems::Candidate::InitialTeacherTrainingYearResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa7", value: "Example 2"),
                ]
              end
            end
          end
        end
      end
    end
  end
end
