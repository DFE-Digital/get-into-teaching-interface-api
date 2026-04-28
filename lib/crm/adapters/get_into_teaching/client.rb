# frozen_string_literal: true

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

        def lookup_items
          Resources::LookUpItemsResource.new(self)
        end

        def connection
          @connection ||= Faraday.new(base_url) do |conn|
            conn.request :authorization, :Bearer, api_key
            conn.request :json
            conn.response :json, content_type: "application/json"
          end
        end
      end
    end
  end
end
