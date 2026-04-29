module CRM
  module Resources
    class LookUpItemsResource
      def countries(*) = raise NotImplementedError

      def degree_countries(*) = raise NotImplementedError

      def teaching_subjects(*) = raise NotImplementedError
    end
  end
end
