module CRM
  module Resources
    class TeachingEventBuildingResource < BaseStruct
      attribute :venue, Types::String
      attribute :address_line1, Types::String.optional
      attribute :address_line2, Types::String.optional
      attribute :address_line3, Types::String.optional
      attribute :address_city, Types::String.optional
      attribute :address_postcode, Types::String.optional
      attribute :image_url, Types::String.optional
      attribute :id, Types::String
    end
  end
end
