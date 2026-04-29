# frozen_string_literal: true

module CRM
  module Resources
    module PickListItems
      module Candidate
        class InitialTeacherTrainingYearsResource
          # @return [Array<CRM::Resources::PickListItems::Candidate::InitialTeacherTrainingYearResource]
          def all(*)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
