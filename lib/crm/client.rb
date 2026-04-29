# frozen_string_literal: true

module CRM
  class Client
    def initialize(adapter: CRM::Adapters::Demo::Client.new)
      @adapter = adapter
    end

    def lookup_items
      @adapter.lookup_items
    end

    def pick_list_items
      @adapter.pick_list_items
    end
  end
end
