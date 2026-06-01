module CRM
  module Adapters
    module GetIntoTeaching
      class Resource
        class Error < StandardError; end
        class NotFoundError < Error; end

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

        def response_to_type(response, type:)
          body = response.body || {}
            type.new(**underscore_and_sym_keys(body))
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
          body = response.body.is_a?(String) ? JSON.parse(response.body) : response.body

          case response.status
          when 400
            raise Error, "Your request was malformed. #{body["errors"].values.flatten}"
          when 401
            raise Error, "You did not supply valid authentication credentials. #{body["errors"].values.flatten}"
          when 403
            raise Error, "You are not allowed to perform that action. #{body["errors"].values.flatten}"
          when 422
            raise Error, "Your request was well-formed but contained invalid data. #{body["errors"].values.flatten}"
          when 404
            raise NotFoundError, "No results were found for your request. #{body["errors"].values.flatten}"
          when 500
            raise Error, "We were unable to perform the request due to server-side problems. #{body["errors"].values.flatten}"
          when 503
            raise Error, "We were unable to perform the request, due to ongoing maintenance. #{body["errors"].values.flatten}"
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
