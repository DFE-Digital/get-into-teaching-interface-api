# frozen_string_literal: true

module CRM
  module Adapters
    module Demo
      class Client
        def lookup_items
          Resources::LookUpItemsResource.new
        end
      end
    end
  end
end
