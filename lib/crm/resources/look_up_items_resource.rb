# frozen_string_literal: true

module CRM
  module Resources
    class LookUpItemsResource
      def countries(*)
        raise NotImplementedError
      end

      def degree_countries(*)
        raise NotImplementedError
      end
    end
  end
end
