module CRM
  module Resources
    class TeachingEventAddAttendeeResource < BaseStruct
      attribute :candidate_id,     Types::String.optional
      attribute :qualification_id, Types::String.optional
      attribute :preferred_teaching_subject_id, Types::String.optional
      attribute :consideration_journey_stage_id, Types::Integer.optional
      attribute :degree_status_id, Types::Integer.optional
      attribute :email,            Types::String
      attribute :first_name,       Types::String.optional
      attribute :last_name,        Types::String.optional
      attribute :address_postcode, Types::String.optional
      attribute :address_telephone, Types::String.optional
      attribute :is_verified,      Types::Params::Bool.optional
      attribute :already_subscribed_to_events, Types::Params::Bool.optional
      attribute :already_subscribed_to_mailing_list, Types::Params::Bool.optional
      attribute :already_subscribed_to_teacher_training_adviser, Types::Params::Bool.optional
      attribute :accessibility_needs_for_event, Types::String.optional
      attribute :event_id,         Types::String.optional
      attribute :channel_id,       Types::String.optional
      attribute :accepted_policy_id, Types::String.optional
      attribute :is_walk_in,       Types::Params::Bool.optional
      attribute :subscribe_to_mailing_list, Types::Params::Bool.optional
      attribute :creation_channel_source_id, Types::String.optional
      attribute :creation_channel_service_id, Types::String.optional
      attribute :creation_channel_activity_id, Types::String.optional
      attribute :default_contact_creation_channel, Types::Integer.optional
      attribute :default_creation_channel_source_id, Types::Integer.optional
      attribute :default_creation_channel_service_id, Types::Integer.optional
      attribute :default_creation_channel_activity_id, Types::Integer.optional
    end
  end
end
