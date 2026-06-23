module CRM
  module Resources
    module SchoolsExperience
      CandidateResource = Data.define(
        :candidate_id,
        :email,
        :first_name,
        :last_name,
        :preferred_teaching_subject_id,
        :secondary_preferred_teaching_subject_id,
        :address_line1,
        :address_line2,
        :address_line3,
        :address_city,
        :address_state_or_province,
        :address_postcode,
        :telephone,
        :has_dbs_certificate,
        :dbs_certificate_issued_at,
        :qualification_id,
        :degree_status_id,
        :degree_type_id,
        :degree_subject,
        :uk_degree_grade_id,
        :creation_channel_source_id,
        :creation_channel_service_id,
        :creation_channel_activity_id,
        :accepted_policy_id,
      )
    end
  end
end
