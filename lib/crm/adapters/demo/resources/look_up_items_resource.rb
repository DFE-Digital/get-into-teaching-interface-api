module CRM
  module Adapters
    module Demo
      module Resources
        class LookUpItemsResource < CRM::Resources::LookUpItemsResource
          def countries
            LookUpItems::CountriesResource.new
          end

          def degree_countries
            LookUpItems::DegreeCountriesResource.new
          end

          def teaching_subjects
            LookUpItems::TeachingSubjectsResource.new
          end
        end
      end
    end
  end
end
