module CRM
  module Adapters
    module Demo
      module Resources
        class MailingListResource
          def create_member(_body)
            CRM::Resources::TeacherTrainingAdviser::DegreeResource.new(
              degree_status_id: 222750000
            )
          end

          def exchange_access_token(_token, _body)
            CRM::Resources::MailingList::CandidateResource.new(
              candidate_id: "0a857c51-696c-4b02-ba71-75b31ccef673",
              qualification_id: nil,
              preferred_teaching_subject_id: "b02655a1-2afa-e811-a981-000d3a276620",
              accepted_policy_id: nil,
              consideration_journey_stage_id: nil,
              channel_id: nil,
              creation_channel_source_id: nil,
              creation_channel_service_id: nil,
              creation_channel_activity_id: nil,
              email: "johndoe@example.com",
              first_name: "john",
              last_name: "doe",
              address_postcode: "M20 4AA",
              welcome_guide_variant: nil,
              already_subscribed_to_events: false,
              already_subscribed_to_mailing_list: false,
              already_subscribed_to_teacher_training_adviser: true,
              default_contact_creation_channel: 222750028,
              default_creation_channel_source_id: 222750003,
              default_creation_channel_service_id: 222750007,
              default_creation_channel_activity_id: nil,
              situation: nil,
              citizenship: nil,
              visa_status: nil,
              location: nil,
              graduation_year: nil,
              inferred_graduation_date: nil,
              degree_status_id: nil,
            )
          end
        end
      end
    end
  end
end
