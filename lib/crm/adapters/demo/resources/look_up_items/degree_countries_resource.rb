# frozen_string_literal: true

module CRM
  module Adapters
    module Demo
      module Resources
        module LookUpItems
          class DegreeCountriesResource < CRM::Resources::LookUpItems::DegreeCountriesResource
            def all(*)
              [
                CRM::Resources::LookUpItems::DegreeCountryResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", value: "United States", iso_code: "US"),
                CRM::Resources::LookUpItems::DegreeCountryResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", value: "Canada", iso_code: "CA"),
                CRM::Resources::LookUpItems::DegreeCountryResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", value: "United Kingdom", iso_code: "GB"),
                CRM::Resources::LookUpItems::DegreeCountryResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", value: "Australia", iso_code: "AU"),
                CRM::Resources::LookUpItems::DegreeCountryResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", value: "Germany", iso_code: "DE"),
              ]
            end
          end
        end
      end
    end
  end
end
