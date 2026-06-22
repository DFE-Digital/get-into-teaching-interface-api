module CRM
  module Adapters
    module Demo
      module Resources
        class SchoolsExperienceResource
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
        end
      end
    end
  end
end
