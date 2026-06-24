module CRM
  module Adapters
    module Demo
      module Resources
        class SchoolsExperienceResource < CRM::Resources::SchoolsExperienceResource
          def all(*)
            [
              CRM::Resources::SchoolsExperience::CandidateResource.new(
                candidate_id: "abc-123",
                email: "johndoe@example.com",
                first_name: "John",
                last_name: "Doe",
                preferred_teaching_subject_id: "subject-1",
                secondary_preferred_teaching_subject_id: "subject-2",
                address_line1: "123 Main St",
                address_line2: "Apt 4B",
                address_line3: "Little Whinging",
                address_city: "London",
                address_state_or_province: "London",
                address_postcode: "SW1A 1AA",
                telephone: "01234567890",
                has_dbs_certificate: true,
                dbs_certificate_issued_at: "2024-01-15",
                qualification_id: "qual-1",
                degree_status_id: "status-1",
                degree_type_id: "type-1",
                degree_subject: "Mathematics",
                uk_degree_grade_id: "grade-1",
                creation_channel_source_id: "source-1",
                creation_channel_service_id: "service-1",
                creation_channel_activity_id: "activity-1",
                accepted_policy_id: "policy-1",
                master_id: nil,
                merged: false,
                full_name: "John Doe",
                default_contact_creation_channel: nil,
                default_creation_channel_source_id: nil,
                default_creation_channel_service_id: nil,
                default_creation_channel_activity_id: nil,
              ),
            ]
          end

          def find(id)
            CRM::Resources::SchoolsExperience::CandidateResource.new(
              candidate_id: id,
              email: "johndoe@example.com",
              first_name: "John",
              last_name: "Doe",
              preferred_teaching_subject_id: "subject-1",
              secondary_preferred_teaching_subject_id: "subject-2",
              address_line1: "123 Main St",
              address_line2: "Apt 4B",
              address_line3: "Little Whinging",
              address_city: "London",
              address_state_or_province: "London",
              address_postcode: "SW1A 1AA",
              telephone: "01234567890",
              has_dbs_certificate: true,
              dbs_certificate_issued_at: "2024-01-15",
              qualification_id: "qual-1",
              degree_status_id: "status-1",
              degree_type_id: "type-1",
              degree_subject: "Mathematics",
              uk_degree_grade_id: "grade-1",
              creation_channel_source_id: "source-1",
              creation_channel_service_id: "service-1",
              creation_channel_activity_id: "activity-1",
               accepted_policy_id: "policy-1",
               master_id: nil,
               merged: false,
               full_name: "John Doe",
               default_contact_creation_channel: nil,
               default_creation_channel_source_id: nil,
               default_creation_channel_service_id: nil,
               default_creation_channel_activity_id: nil,
             )
           end

           def create_candidate(_body)
            CRM::Resources::SchoolsExperience::CandidateResource.new(
              candidate_id: "abc-123",
              email: "johndoe@example.com",
              first_name: "John",
              last_name: "Doe",
              preferred_teaching_subject_id: "subject-1",
              secondary_preferred_teaching_subject_id: "subject-2",
              address_line1: "123 Main St",
              address_line2: "Apt 4B",
              address_line3: "Little Whinging",
              address_city: "London",
              address_state_or_province: "London",
              address_postcode: "SW1A 1AA",
              telephone: "01234567890",
              has_dbs_certificate: true,
              dbs_certificate_issued_at: "2024-01-15",
              qualification_id: "qual-1",
              degree_status_id: "status-1",
              degree_type_id: "type-1",
              degree_subject: "Mathematics",
              uk_degree_grade_id: "grade-1",
              creation_channel_source_id: "source-1",
              creation_channel_service_id: "service-1",
              creation_channel_activity_id: "activity-1",
               accepted_policy_id: "policy-1",
               master_id: nil,
               merged: false,
               full_name: "John Doe",
               default_contact_creation_channel: nil,
               default_creation_channel_source_id: nil,
               default_creation_channel_service_id: nil,
               default_creation_channel_activity_id: nil,
             )
           end

           def create_school_experience(_id, _body)
            Data.define(:body).new(body: {})
          end

          def exchange_access_token(_token, _body)
            CRM::Resources::SchoolsExperience::CandidateResource.new(
              candidate_id: "abc-123",
              email: "johndoe@example.com",
              first_name: "John",
              last_name: "Doe",
              preferred_teaching_subject_id: "subject-1",
              secondary_preferred_teaching_subject_id: "subject-2",
              address_line1: "123 Main St",
              address_line2: "Apt 4B",
              address_line3: "Little Whinging",
              address_city: "London",
              address_state_or_province: "London",
              address_postcode: "SW1A 1AA",
              telephone: "01234567890",
              has_dbs_certificate: true,
              dbs_certificate_issued_at: "2024-01-15",
              qualification_id: "qual-1",
              degree_status_id: "status-1",
              degree_type_id: "type-1",
              degree_subject: "Mathematics",
              uk_degree_grade_id: "grade-1",
              creation_channel_source_id: "source-1",
              creation_channel_service_id: "service-1",
              creation_channel_activity_id: "activity-1",
               accepted_policy_id: "policy-1",
               master_id: nil,
               merged: false,
               full_name: "John Doe",
               default_contact_creation_channel: nil,
               default_creation_channel_source_id: nil,
               default_creation_channel_service_id: nil,
               default_creation_channel_activity_id: nil,
             )
           end
        end
      end
    end
  end
end
