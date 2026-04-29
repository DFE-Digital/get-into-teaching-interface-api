module CRM
  module Resources
    module LookUpItems
      class CountriesResource
        # @return [Array<CRM::Resources::LookUpItems::CountryResource>]
        def all(*)
          raise NotImplementedError
        end
      end
    end
  end
end
