module CRM
  module Adapters
    module Demo
      module Resources
        class GetIntoTeachingResource
          def create_callback(_body)
            true
          end

          def exchange_access_token(_token, _body)
            CRM::Resources::GetIntoTeaching::CandidateResource.new(
              candidate_id: "0a857c51-696c-4b02-ba71-75b31ccef673",
              accepted_policy_id: nil,
              email: "johndoe@example.com",
              first_name: "john",
              last_name: "doe",
              address_telephone: nil,
              phone_call_scheduled_at: nil,
              talking_points: nil,
              creation_channel_source_id: nil,
              creation_channel_service_id: nil,
              creation_channel_activity_id: nil,
              default_contact_creation_channel: 222750043,
              default_creation_channel_source_id: 222750003,
              default_creation_channel_service_id: 222750007,
              default_creation_channel_activity_id: nil,
            )
          end

          def matchback(_body)
            CRM::Resources::GetIntoTeaching::CandidateResource.new(
              candidate_id: "0a857c51-696c-4b02-ba71-75b31ccef673",
              accepted_policy_id: nil,
              email: "johndoe@example.com",
              first_name: "john",
              last_name: "doe",
              address_telephone: nil,
              phone_call_scheduled_at: nil,
              talking_points: nil,
              creation_channel_source_id: nil,
              creation_channel_service_id: nil,
              creation_channel_activity_id: nil,
              default_contact_creation_channel: 222750043,
              default_creation_channel_source_id: 222750003,
              default_creation_channel_service_id: 222750007,
              default_creation_channel_activity_id: nil,
            )
          end
        end
      end
    end
  end
end
