module CRM
  module Adapters
    module Demo
      module Resources
        module PickListItems
          class PastTeachingPositionResource < CRM::Resources::PickListItems::PastTeachingPositionResource
            def education_phases
              PastTeachingPosition::EducationPhasesResource.new
            end
          end
        end
      end
    end
  end
end
