module CRM
  module Adapters
    module Demo
      module Resources
        module TeacherTrainingAdviser
          class Resource
            SIGN_UP_RESPONSE = {
              "candidateId" => "551fee4b-9b6c-4cfc-a579-ed9bf9bcadbb",
              "qualificationId" => "72a05d00-60b5-49f3-b85e-f80f0d597c15",
              "subjectTaughtId" => nil,
              "pastTeachingPositionId" => nil,
              "preferredTeachingSubjectId" => "b02655a1-2afa-e811-a981-000d3a276620",
              "countryId" => "72f5c2e6-74f9-e811-a97a-000d3a2760f2",
              "acceptedPolicyId" => nil,
              "typeId" => 222750000,
              "ukDegreeGradeId" => 222750002,
              "degreeTypeId" => 222750000,
              "initialTeacherTrainingYearId" => 22304,
              "stageTaughtId" => nil,
              "preferredEducationPhaseId" => 222750000,
              "hasGcseMathsAndEnglishId" => 222750000,
              "hasGcseScienceId" => 222750000,
              "planningToRetakeGcseMathsAndEnglishId" => nil,
              "planningToRetakeGcseScienceId" => 222750001,
              "adviserStatusId" => nil,
              "channelId" => nil,
              "degreeCountry" => nil,
              "creationChannelSourceId" => nil,
              "creationChannelServiceId" => nil,
              "creationChannelActivityId" => nil,
              "email" => "johndoe@example.com",
              "firstName" => "john",
              "lastName" => "doe",
              "dateOfBirth" => "1980-06-06T00:00:00",
              "teacherId" => nil,
              "degreeSubject" => "Computing",
              "addressTelephone" => nil,
              "addressPostcode" => "W1 1ED",
              "phoneCallScheduledAt" => nil,
              "canSubscribeToTeacherTrainingAdviser" => false,
              "assignmentStatusId" => 222750001,
              "defaultContactCreationChannel" => 222750027,
              "defaultCreationChannelSourceId" => 222750003,
              "defaultCreationChannelServiceId" => 222750010,
              "defaultCreationChannelActivityId" => nil,
              "graduationYear" => nil,
              "inferredGraduationDate" => nil,
              "situation" => nil,
              "citizenship" => nil,
              "visaStatus" => nil,
              "location" => nil,
              "degreeStatusId" => 222750000,
            }.freeze

            def create_candidate(_body)
              true
            end

            def exchange_access_token(_token, _body)
              Data.define(:body).new(body: SIGN_UP_RESPONSE)
            end

            def matchback(_body)
              Data.define(:body).new(body: SIGN_UP_RESPONSE)
            end
          end
        end
      end
    end
  end
end
