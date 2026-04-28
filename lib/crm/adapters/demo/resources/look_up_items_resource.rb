# frozen_string_literal: true

module CRM
  module Adapters
    module Demo
      module Resources
        class LookUpItemsResource < CRM::Resources::LookUpItemsResource
          def countries
            LookUpItems::CountriesResource.new
          end
        end
      end
    end
  end
end
