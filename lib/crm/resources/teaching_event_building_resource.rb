module CRM
  module Resources
    TeachingEventBuildingResource = Data.define(
      :venue,
      :address_line1,
      :address_line2,
      :address_line3,
      :address_city,
      :address_postcode,
      :image_url,
      :id,
    )
  end
end
