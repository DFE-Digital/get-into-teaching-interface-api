module CRM
  module Resources
    module LookUpItems
      class CountryResource < BaseStruct
        attribute :id, Types::String
        attribute :value, Types::String
        attribute :iso_code, Types::String.optional
      end
    end
  end
end
