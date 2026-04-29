module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          class QualificationResource < CRM::Resources::PickListItems::QualificationResource
            def initialize(client)
              @client = client
            end

            def degree_statuses = Qualification::DegreeStatusesResource.new(@client)

            def types = Qualification::TypesResource.new(@client)
          end
        end
      end
    end
  end
end
