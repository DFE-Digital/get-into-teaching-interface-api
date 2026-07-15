module CRM
  module Resources
    module SchoolsExperience
      class CandidateResource < BaseStruct
        attribute :candidate_id,   Types::String.optional
        attribute :preferred_teaching_subject_id, Types::String.optional
        attribute :secondary_preferred_teaching_subject_id, Types::String.optional
        attribute :accepted_policy_id, Types::String.optional
        attribute :master_id,      Types::String.optional
        attribute :merged,         Types::Params::Bool
        attribute :full_name,      Types::String
        attribute :email,          Types::String
        attribute :first_name,     Types::String.optional
        attribute :last_name,      Types::String.optional
        attribute :address_line1,  Types::String.optional
        attribute :address_line2,  Types::String.optional
        attribute :address_line3,  Types::String.optional
        attribute :address_city,   Types::String.optional
        attribute :address_state_or_province, Types::String.optional
        attribute :address_postcode, Types::String
        attribute :telephone,      Types::String
        attribute :has_dbs_certificate, Types::Params::Bool.optional
        attribute :dbs_certificate_issued_at, Types::String.optional
        attribute :qualification_id, Types::String.optional
        attribute :degree_status_id, Types::Integer.optional
        attribute :degree_type_id, Types::Integer.optional
        attribute :degree_subject, Types::String.optional
        attribute :uk_degree_grade_id, Types::Integer.optional
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
end
