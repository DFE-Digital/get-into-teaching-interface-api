module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class OperationResource < CRM::Adapters::GetIntoTeaching::Resource
          def health_check
            response = get_request("/api/operations/health_check")
            response_to_type(response, type: CRM::Resources::Operations::HealthCheckResource)
          end
        end
      end
    end
  end
end
