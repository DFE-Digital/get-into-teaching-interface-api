module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class TeachingEventsResource < CRM::Adapters::GetIntoTeaching::Resource
          def all(params)
            response = get_request("/api/teaching_events/search", params:)
            response.body.map do |attrs|
              attrs.deep_transform_keys(&:underscore).deep_transform_keys(&:to_sym)
            end
          end

          def find(id)
            response = get_request("/api/teaching_events/#{id}")
            response.body.deep_transform_keys(&:underscore).deep_transform_keys(&:to_sym)
          end

          def create(body)
            response = post_request("/api/teaching_events", body:)
            response.body.deep_transform_keys(&:underscore).deep_transform_keys(&:to_sym)
          end

          def create_attendee(body)
            post_request("/api/teaching_events/attendees", body:)
          end

          def exchange_unverified_request(body)
            response = post_request("app/views/api/teaching_events/exchange_unverified_requests", body:)
            response.body.deep_transform_keys(&:underscore).deep_transform_keys(&:to_sym)
          end

          def exchange_access_token(token, body)
            response = post_request("/api/teaching_events/attendees/exchange_access_token/#{token}", body:)
            response.body.deep_transform_keys(&:underscore).deep_transform_keys(&:to_sym)
          end
        end
      end
    end
  end
end
