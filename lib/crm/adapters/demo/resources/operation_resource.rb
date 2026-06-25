module CRM
  module Adapters
    module Demo
      module Resources
        class OperationResource
          def health_check
            CRM::Resources::Operations::HealthCheckResource.new(
              git_commit_sha: "abc123",
              environment: "test",
              database: "ok",
              hangfire: "ok",
              crm: "ok",
              redis: "ok",
              notify: "ok",
              status: "healthy",
            )
          end

          def generate_mapping_info
            [
              { class: "Candidate", logical_name: "contact" },
              { class: "TeachingEvent", logical_name: "msevtmgt_event" },
            ]
          end

          def pause_crm_integration
            true
          end

          def resume_crm_integration
            true
          end

          def backfill_apply_candidates(**)
            true
          end

          def backfill_apply_candidates_from_ids(**)
            true
          end
        end
      end
    end
  end
end
