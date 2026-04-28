# frozen_string_literal: true

module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class LookUpItemsResource < CRM::Resources::LookUpItemsResource
          def initialize(client)
            @client = client
          end

          def countries
            LookUpItems::CountriesResource.new(@client)
          end

          def degree_countries
            LookUpItems::DegreeCountriesResource.new(@client)
          end
        end
      end
    end
  end
end
