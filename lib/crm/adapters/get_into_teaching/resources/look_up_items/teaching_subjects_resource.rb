# frozen_string_literal: true

module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module LookUpItems
          class TeachingSubjectsResource < CRM::Adapters::GetIntoTeaching::Resource
            def all(**params)
              response = get_request("/api/lookup_items/teaching_subjects", params: params)
              response_to_collection(response, type: CRM::Resources::LookUpItems::TeachingSubjectResource)
            end
          end
        end
      end
    end
  end
end
