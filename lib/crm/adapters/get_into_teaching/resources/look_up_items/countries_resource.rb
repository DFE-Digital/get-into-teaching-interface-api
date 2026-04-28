# frozen_string_literal: true

module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module LookUpItems
          class CountriesResource < CRM::Adapters::GetIntoTeaching::Resource
            def all(**params)
              response = get_request("/api/lookup_items/countries", params: params)
              response_to_collection(response, type: CRM::Resources::LookUpItems::CountryResource)
            end
          end
        end
      end
    end
  end
end
