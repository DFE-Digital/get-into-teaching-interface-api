module CRM
  module Resources
    module TeacherTrainingAdviser
      class CandidateResource < BaseStruct
        attribute :candidate_id,   Types::String.optional
        attribute :qualification_id, Types::String.optional
        attribute :subject_taught_id, Types::String.optional
        attribute :past_teaching_position_id, Types::String.optional
        attribute :preferred_teaching_subject_id, Types::String.optional
        attribute :country_id,     Types::String.optional
        attribute :accepted_policy_id, Types::String.optional
        attribute :type_id,        Types::Integer.optional
        attribute :uk_degree_grade_id, Types::Integer.optional
        attribute :degree_type_id, Types::Integer.optional
        attribute :initial_teacher_training_year_id, Types::Integer.optional
        attribute :stage_taught_id, Types::Integer.optional
        attribute :preferred_education_phase_id, Types::Integer.optional
        attribute :has_gcse_maths_and_english_id, Types::Integer.optional
        attribute :has_gcse_science_id, Types::Integer.optional
        attribute :planning_to_retake_gcse_maths_and_english_id, Types::Integer.optional
        attribute :planning_to_retake_gcse_science_id, Types::Integer.optional
        attribute :adviser_status_id, Types::Integer.optional
        attribute :channel_id,     Types::Integer.optional
        attribute :degree_country, Types::String.optional
        attribute :creation_channel_source_id, Types::Integer.optional
        attribute :creation_channel_service_id, Types::Integer.optional
        attribute :creation_channel_activity_id, Types::Integer.optional
        attribute :email,          Types::String
        attribute :first_name,     Types::String.optional
        attribute :last_name,      Types::String.optional
        attribute :date_of_birth,  Types::String.optional
        attribute :teacher_id,     Types::String.optional
        attribute :degree_subject, Types::String.optional
        attribute :address_telephone, Types::String.optional
        attribute :address_postcode, Types::String.optional
        attribute :phone_call_scheduled_at, Types::String.optional
        attribute :can_subscribe_to_teacher_training_adviser, Types::Params::Bool
        attribute :assignment_status_id, Types::Integer.optional
        attribute :default_contact_creation_channel, Types::Integer.optional
        attribute :default_creation_channel_source_id, Types::Integer.optional
        attribute :default_creation_channel_service_id, Types::Integer.optional
        attribute :default_creation_channel_activity_id, Types::Integer.optional
        attribute :graduation_year, Types::String.optional
        attribute :inferred_graduation_date, Types::String.optional
        attribute :situation,      Types::String.optional
        attribute :citizenship,    Types::String.optional
        attribute :visa_status,    Types::String.optional
        attribute :location,       Types::String.optional
        attribute :degree_status_id, Types::Integer.optional
      end
    end
  end
end
