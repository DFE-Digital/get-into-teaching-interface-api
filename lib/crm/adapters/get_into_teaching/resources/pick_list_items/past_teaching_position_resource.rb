module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module PickListItems
          class PastTeachingPositionResource < CRM::Resources::PickListItems::PastTeachingPositionResource
            def initialize(client)
              @client = client
            end

            def education_phases = PastTeachingPosition::EducationPhasesResource.new(@client)
          end
        end
      end
    end
  end
end
