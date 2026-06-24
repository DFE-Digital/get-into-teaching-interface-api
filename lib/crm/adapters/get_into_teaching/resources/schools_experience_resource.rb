module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class SchoolsExperienceResource < CRM::Adapters::GetIntoTeaching::Resource
          def all(**params)
            response = get_request("/api/schools_experience/candidates", params:)
            response_to_collection(response, type: CRM::Resources::SchoolsExperience::CandidateResource)
          end

          def find(id, **params)
            response = get_request("/api/schools_experience/candidates/#{id}", params:)
            response_to_type(response, type: CRM::Resources::SchoolsExperience::CandidateResource)
          end

          def create_candidate(body)
            response = post_request("/api/schools_experience/candidates", body:)
            response_to_type(response, type: CRM::Resources::SchoolsExperience::CandidateResource)
          end

          def exchange_access_token(token, body)
            response = post_request("/api/schools_experience/candidates/exchange_access_token/#{token}", body:)
            response_to_type(response, type: CRM::Resources::SchoolsExperience::CandidateResource)
          end

          def create_school_experience(id, body)
            post_request("/api/schools_experience/candidates/#{id}/school_experience", body:)
          end
        end
      end
    end
  end
end
