module CRM
  module Adapters
    module Demo
      module Resources
        class PrivacyPoliciesResource < CRM::Resources::PrivacyPoliciesResource

          def find(id)
            CRM::Resources::PrivacyPolicyResource.new(
              id: id,
              text: "This is a demo privacy policy for testing purposes.",
              created_at: "2026-04-30T09:36:47.357Z"
            )
          end
        end
      end
    end
  end
end
