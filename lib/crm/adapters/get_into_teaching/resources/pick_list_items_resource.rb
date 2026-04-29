module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class PickListItemsResource < CRM::Resources::PickListItemsResource
          def initialize(client)
            @client = client
          end

          def candidate = PickListItems::CandidateResource.new(@client)

          def qualification = PickListItems::QualificationResource.new(@client)

          def past_teaching_position = PickListItems::PastTeachingPositionResource.new(@client)

          def teaching_event = PickListItems::TeachingEventResource.new(@client)
        end
      end
    end
  end
end
