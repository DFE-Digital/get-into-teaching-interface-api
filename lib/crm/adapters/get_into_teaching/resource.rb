module CRM
  module Adapters
    module GetIntoTeaching
      class Resource
        class Error < StandardError; end
        class NotFoundError < Error; end
        class BadRequestError < Error; end
        class UnauthorizedError < Error; end
        class Forbidden < Error; end

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

        def post_request(url, body:, headers: {}, params: {})
          handle_response client.connection.post(url, body, headers) do |request|
            request.params.merge!(params)
          end
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
            # Change this when the C# api returns errors in better format
            errors = if response.body.is_a?(String)
              begin
                JSON.parse(response.body)["errors"].presence
              rescue JSON::ParserError
                response.body
              end
            else
              response.body["error"].presence
            end

            raise BadRequestError, "Your request was malformed. #{errors}"
          when 401
            raise UnauthorizedError, "You did not supply valid authentication credentials. #{response.body["error"]}"
          when 403
            raise Forbidden, "You are not allowed to perform that action. #{response.body["error"]}"
          when 422
            raise Error, "Your request was well-formed but contained invalid data. #{response.body["errors"]}"
          when 404
            raise NotFoundError, "No results were found for your request. #{response.body["error"]}"
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
