module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class PrivacyPoliciesResource < CRM::Adapters::GetIntoTeaching::Resource
          def all(**params)
            response = get_request("/api/privacy_policies", params: params)
            response_to_collection(response, type: CRM::Resources::PrivacyPolicyResource)
          end

          def find(id, **params)
            response = get_request("/api/privacy_policies/#{id}", params: params)
            response_to_type(response, type: CRM::Resources::PrivacyPolicyResource)
          end
        end
      end
    end
  end
end
