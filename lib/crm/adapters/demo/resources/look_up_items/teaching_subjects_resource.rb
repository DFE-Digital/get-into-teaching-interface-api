module CRM
  module Adapters
    module Demo
      module Resources
        module LookUpItems
          class TeachingSubjectsResource < CRM::Resources::LookUpItems::TeachingSubjectsResource
            def all(*)
              [
                CRM::Resources::LookUpItems::TeachingSubjectResource.new(id: "some-id", value: "Art"),
                CRM::Resources::LookUpItems::TeachingSubjectResource.new(id: "some-id", value: "Art & Design"),
                CRM::Resources::LookUpItems::TeachingSubjectResource.new(id: "some-id", value: "Chemistry"),
              ]
            end
          end
        end
      end
    end
  end
end
