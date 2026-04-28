# frozen_string_literal: true

module CRM
  module Resources
    module LookUpItems
      class TeachingSubjectsResource
        # @return [Array<CRM::Resources::LookUpItems::TeachingSubject>]
        def all(*) = raise NotImplementedError
      end
    end
  end
end
