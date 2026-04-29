module CRM
  module Resources
    class PickListItemsResource
      def candidate(*) = raise NotImplementedError

      def qualification(*) = raise NotImplementedError

      def past_teaching_position(*) = raise NotImplementedError
    end
  end
end
