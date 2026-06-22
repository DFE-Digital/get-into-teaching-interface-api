module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class SchoolsExperienceResource < CRM::Adapters::GetIntoTeaching::Resource
          def create_candidate(body)
            post_request("/api/schools_experience/candidates", body:)
          end
        end
      end
    end
  end
end
