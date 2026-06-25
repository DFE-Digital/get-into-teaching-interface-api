module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class OperationResource < CRM::Adapters::GetIntoTeaching::Resource
          def health_check
            response = get_request("/api/operations/health_check")
            response_to_type(response, type: CRM::Resources::Operations::HealthCheckResource)
          end

          def generate_mapping_info
            response = get_request("/api/operations/generate_mapping_info")
            response.body.map do |attrs|
              attrs.deep_transform_keys(&:underscore).deep_transform_keys(&:to_sym)
            end
          end

          def pause_crm_integration
            put_request("/api/operations/pause_crm_integration", body: {})
          end

          def resume_crm_integration
            put_request("/api/operations/resume_crm_integration", body: {})
          end

          def backfill_apply_candidates(**params)
            post_request("/api/operations/backfill_apply_candidates", body: {}, params:)
          end

          def backfill_apply_candidates_from_ids(**params)
            post_request("/api/operations/backfill_apply_candidates_from_ids", body: {}, params:)
          end
        end
      end
    end
  end
end
