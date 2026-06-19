module CRM
  module Adapters
    module GetIntoTeaching
      class Client
        attr_reader :base_url, :api_key

        def initialize(base_url: ENV["GET_INTO_TEACHING_BASE_URL"],
                       api_key: ENV["GET_INTO_TEACHING_API_KEY"]
        )
          @base_url = base_url
          @api_key = api_key
        end

        def connection
          @connection ||= Faraday.new(base_url) do |conn|
            conn.request :authorization, :Bearer, api_key
            conn.request :json
            conn.response :json, content_type: "application/json"
          end
        end

        def lookup_items
          Resources::LookUpItemsResource.new(self)
        end

        def pick_list_items
          Resources::PickListItemsResource.new(self)
        end

        def callback_booking_quotas
          Resources::CallbackBookingQuotasResource.new(self)
        end

        def teaching_event_buildings
          Resources::TeachingEventBuildingsResource.new(self)
        end

        def privacy_policies
          Resources::PrivacyPoliciesResource.new(self)
        end

        def teacher_training_adviser
          Resources::TeacherTrainingAdviser::Resource.new(self)
        end

        def candidates
          Resources::CandidatesResource.new(self)
        end

        def mailing_list
          Resources::MailingListResource.new(self)
        end

        def get_into_teaching
          Resources::GetIntoTeachingResource.new(self)
        end
      end
    end
  end
end
