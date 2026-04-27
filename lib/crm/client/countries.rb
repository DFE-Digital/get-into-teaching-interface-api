module CRM
  module Client
    class Countries
      def initialize(adapter: CRM::Adapters::Demo::Countries.new)
        @adapter = adapter
      end

      def all
        @adapter.all
      end
    end
  end
end
