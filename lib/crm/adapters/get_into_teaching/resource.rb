# frozen_string_literal: true

module CRM
  module Adapters
    module GetIntoTeaching
      class Resource
        class Error < StandardError; end

        attr_reader :client

        def initialize(client)
          @client = client
        end

        def response_to_collection(response, type:)
          body = response.body || []
          body.map do |attrs|
            type.new(**underscore_and_sym_keys(attrs))
          end
        end

        def get_request(url, params: {}, headers: {})
          handle_response client.connection.get(url, params, headers)
        end

        def post_request(url, body:, headers: {})
          handle_response client.connection.post(url, body, headers)
        end

        def patch_request(url, body:, headers: {})
          handle_response client.connection.patch(url, body, headers)
        end

        def put_request(url, body:, headers: {})
          handle_response client.connection.put(url, body, headers)
        end

        def delete_request(url, params: {}, headers: {})
          handle_response client.connection.delete(url, params, headers)
        end

        def handle_response(response)
          case response.status
          when 400
            raise Error, "Your request was malformed. #{response.body["error"]}"
          when 401
            raise Error, "You did not supply valid authentication credentials. #{response.body["error"]}"
          when 403
            raise Error, "You are not allowed to perform that action. #{response.body["error"]}"
          when 422
            raise Error, "Your request was well-formed but contained invalid data. #{response.body["errors"]}"
          when 404
            raise Error, "No results were found for your request. #{response.body["error"]}"
          when 500
            raise Error, "We were unable to perform the request due to server-side problems. #{response.body["error"]}"
          when 503
            raise Error, "We were unable to perform the request, due to ongoing maintenance. #{response.body["error"]}"
          else
            nil
          end

          response
        end

        private

        def underscore_and_sym_keys(attrs)
          attrs.transform_keys(&:underscore).transform_keys(&:to_sym)
        end
      end
    end
  end
end
