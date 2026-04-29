module CRM
  module Adapters
    module Demo
      module Resources
        module PickListItems
          class QualificationResource < CRM::Resources::PickListItems::QualificationResource
            def degree_statuses
              Qualification::DegreeStatusesResource.new
            end

            def types
              Qualification::TypesResource.new
            end
          end
        end
      end
    end
  end
end
