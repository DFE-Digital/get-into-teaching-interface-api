module CRM
  module Resources
    module MailingList
      class CandidateResource < BaseStruct
        attribute :candidate_id,   Types::String.optional
        attribute :qualification_id, Types::String.optional
        attribute :preferred_teaching_subject_id, Types::String.optional
        attribute :accepted_policy_id, Types::String.optional
        attribute :consideration_journey_stage_id, Types::Integer.optional
        attribute :channel_id,     Types::Integer.optional
        attribute :creation_channel_source_id, Types::Integer.optional
        attribute :creation_channel_service_id, Types::Integer.optional
        attribute :creation_channel_activity_id, Types::Integer.optional
        attribute :email,          Types::String
        attribute :first_name,     Types::String.optional
        attribute :last_name,      Types::String.optional
        attribute :address_postcode, Types::String.optional
        attribute :welcome_guide_variant, Types::String.optional
        attribute :already_subscribed_to_events, Types::Params::Bool
        attribute :already_subscribed_to_mailing_list, Types::Params::Bool
        attribute :already_subscribed_to_teacher_training_adviser, Types::Params::Bool
        attribute :default_contact_creation_channel, Types::Integer.optional
        attribute :default_creation_channel_source_id, Types::Integer.optional
        attribute :default_creation_channel_service_id, Types::Integer.optional
        attribute :default_creation_channel_activity_id, Types::Integer.optional
        attribute :situation,      Types::String.optional
        attribute :citizenship,    Types::String.optional
        attribute :visa_status,    Types::String.optional
        attribute :location,       Types::String.optional
        attribute :graduation_year, Types::String.optional
        attribute :inferred_graduation_date, Types::String.optional
        attribute :degree_status_id, Types::Integer.optional
      end
    end
  end
end
