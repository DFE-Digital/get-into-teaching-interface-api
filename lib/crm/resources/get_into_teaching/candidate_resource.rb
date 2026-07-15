module CRM
  module Resources
    module GetIntoTeaching
      class CandidateResource < BaseStruct
        attribute :candidate_id,   Types::String.optional
        attribute :accepted_policy_id, Types::String.optional
        attribute :email,          Types::String
        attribute :first_name,     Types::String.optional
        attribute :last_name,      Types::String.optional
        attribute :address_telephone, Types::String.optional
        attribute :phone_call_scheduled_at, Types::String.optional
        attribute :talking_points, Types::String.optional
        attribute :creation_channel_source_id, Types::Integer.optional
        attribute :creation_channel_service_id, Types::Integer.optional
        attribute :creation_channel_activity_id, Types::Integer.optional
        attribute :default_contact_creation_channel, Types::Integer.optional
        attribute :default_creation_channel_source_id, Types::Integer.optional
        attribute :default_creation_channel_service_id, Types::Integer.optional
        attribute :default_creation_channel_activity_id, Types::Integer.optional
      end
    end
  end
end
