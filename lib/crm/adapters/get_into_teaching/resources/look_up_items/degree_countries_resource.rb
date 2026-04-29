module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module LookUpItems
          class DegreeCountriesResource < CRM::Adapters::GetIntoTeaching::Resource
            def all(**params)
              response = get_request("/api/lookup_items/degree_countries", params: params)
              response_to_collection(response, type: CRM::Resources::LookUpItems::DegreeCountryResource)
            end
          end
        end
      end
    end
  end
end
