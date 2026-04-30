module CRM
  module Resources
    class PrivacyPoliciesResource
      # @return [CRM::Resources::PrivacyPolicyResource]
      def find(*)
        raise NotImplementedError
      end
    end
  end
end
