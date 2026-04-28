module CRM
  module Adapters
    module Demo
      module Resources
      class CountriesResource < CRM::Resources::CountriesResource
        def all(*)
          [
            CRM::Resources::CountryResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", value: "United States", iso_code: "US"),
            CRM::Resources::CountryResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", value: "Canada", iso_code: "CA"),
            CRM::Resources::CountryResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", value: "United Kingdom", iso_code: "GB"),
            CRM::Resources::CountryResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", value: "Australia", iso_code: "AU"),
            CRM::Resources::CountryResource.new(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", value: "Germany", iso_code: "DE"),
          ]
        end
      end
    end
    end
  end
end
