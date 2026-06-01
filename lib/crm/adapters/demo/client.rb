module CRM
  module Adapters
    module Demo
      class Client
        def lookup_items
          Resources::LookUpItemsResource.new
        end

        def pick_list_items
          Resources::PickListItemsResource.new
        end

        def callback_booking_quotas
          Resources::CallbackBookingQuotasResource.new
        end

        def teaching_event_buildings
          Resources::TeachingEventBuildingsResource.new
        end

        def privacy_policies
          Resources::PrivacyPoliciesResource.new
        end

        def get_into_teaching
          Resources::GetIntoTeachingResource.new
        end
      end
    end
  end
end
