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
            )
          end

          def create_candidate(_body)
            Data.define(:body).new(body: {
              "candidateId" => "abc-123",
              "email" => "johndoe@example.com",
              "firstName" => "John",
              "lastName" => "Doe",
              "preferredTeachingSubjectId" => "subject-1",
              "secondaryPreferredTeachingSubjectId" => "subject-2",
              "addressLine1" => "123 Main St",
              "addressLine2" => "Apt 4B",
              "addressLine3" => "Little Whinging",
              "addressCity" => "London",
              "addressStateOrProvince" => "London",
              "addressPostcode" => "SW1A 1AA",
              "telephone" => "01234567890",
              "hasDbsCertificate" => true,
              "dbsCertificateIssuedAt" => "2024-01-15",
              "qualificationId" => "qual-1",
              "degreeStatusId" => "status-1",
              "degreeTypeId" => "type-1",
              "degreeSubject" => "Mathematics",
              "ukDegreeGradeId" => "grade-1",
              "creationChannelSourceId" => "source-1",
              "creationChannelServiceId" => "service-1",
              "creationChannelActivityId" => "activity-1",
              "acceptedPolicyId" => "policy-1",
            })
          end

          def exchange_access_token(_token, _body)
            Data.define(:body).new(body: {
              "candidateId" => "abc-123",
              "email" => "johndoe@example.com",
              "firstName" => "John",
              "lastName" => "Doe",
              "preferredTeachingSubjectId" => "subject-1",
              "secondaryPreferredTeachingSubjectId" => "subject-2",
              "addressLine1" => "123 Main St",
              "addressLine2" => "Apt 4B",
              "addressLine3" => "Little Whinging",
              "addressCity" => "London",
              "addressStateOrProvince" => "London",
              "addressPostcode" => "SW1A 1AA",
              "telephone" => "01234567890",
              "hasDbsCertificate" => true,
              "dbsCertificateIssuedAt" => "2024-01-15",
              "qualificationId" => "qual-1",
              "degreeStatusId" => "status-1",
              "degreeTypeId" => "type-1",
              "degreeSubject" => "Mathematics",
              "ukDegreeGradeId" => "grade-1",
              "creationChannelSourceId" => "source-1",
              "creationChannelServiceId" => "service-1",
              "creationChannelActivityId" => "activity-1",
              "acceptedPolicyId" => "policy-1",
            })
          end
        end
      end
    end
  end
end
