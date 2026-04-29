# frozen_string_literal: true

module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class PickListItemsResource < CRM::Resources::PickListItemsResource
          def initialize(client)
            @client = client
          end

          def candidate = PickListItems::CandidateResource.new(@client)
        end
      end
    end
  end
end
