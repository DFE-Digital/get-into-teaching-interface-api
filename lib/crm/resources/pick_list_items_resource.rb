module CRM
  module Resources
    class PickListItemsResource
      def candidate(*) = raise NotImplementedError

      def qualification(*) = raise NotImplementedError
    end
  end
end
