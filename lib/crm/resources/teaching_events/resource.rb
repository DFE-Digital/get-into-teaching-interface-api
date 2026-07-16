module CRM
  module Resources
    module TeachingEvents
      class Resource < BaseStruct
        attribute :id,               Types::String
        attribute :type_id,          Types::Integer
        attribute :status_id,        Types::Integer
        attribute :region_id,        Types::Integer.optional
        attribute :readable_id,      Types::String
        attribute :web_feed_id,      Types::String.optional
        attribute :is_online,        Types::Params::Bool
        attribute :name,             Types::String
        attribute :summary,          Types::String.optional
        attribute :message,          Types::String.optional
        attribute :description,      Types::String.optional
        attribute :video_url,        Types::String.optional
        attribute :scribble_id,      Types::String.optional
        attribute :provider_website_url, Types::String.optional
        attribute :provider_target_audience, Types::String.optional
        attribute :provider_organiser, Types::String.optional
        attribute :provider_contact_email, Types::String.optional
        attribute :start_at,         Types::String
        attribute :end_at,           Types::String
        attribute :providers_list,   Types::String.optional
        attribute :is_virtual,       Types::Params::Bool
        attribute :is_in_person,     Types::Params::Bool
        attribute :accessibility_options, Types::Array.of(Types::Integer)
        attribute :building,         BuildingResource.optional
      end
    end
  end
end
