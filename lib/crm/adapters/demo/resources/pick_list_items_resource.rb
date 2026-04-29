module CRM
  module Adapters
    module Demo
      module Resources
        class PickListItemsResource < CRM::Resources::PickListItemsResource
          def candidate
            PickListItems::CandidateResource.new
          end

          def qualification
            PickListItems::QualificationResource.new
          end

          def past_teaching_position
            PickListItems::PastTeachingPositionResource.new
          end

          def teaching_event
            PickListItems::TeachingEventResource.new
          end

          def phone_call
            PickListItems::PhoneCallResource.new
          end

          def service_subscription
            PickListItems::ServiceSubscriptionResource.new
          end

          def contact_creation_channel
            PickListItems::ContactCreationChannelResource.new
          end
        end
      end
    end
  end
end
