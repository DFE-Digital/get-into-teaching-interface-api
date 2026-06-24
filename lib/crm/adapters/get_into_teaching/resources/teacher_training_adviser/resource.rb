module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module TeacherTrainingAdviser
          class Resource < CRM::Adapters::GetIntoTeaching::Resource
            def create_candidate(body)
              response = post_request("/api/teacher_training_adviser/candidates", body:)
              response_to_type(response, type: CRM::Resources::TeacherTrainingAdviser::DegreeResource)
            end

            def matchback(body)
              response = post_request("api/teacher_training_adviser/candidates/matchback", body:)
              response_to_type(response, type: CRM::Resources::TeacherTrainingAdviser::CandidateResource)
            end

            def exchange_access_token(token, body)
              response = post_request("api/teacher_training_adviser/candidates/exchange_access_token/#{token}", body:)
              response_to_type(response, type: CRM::Resources::TeacherTrainingAdviser::CandidateResource)
            end
          end
        end
      end
    end
  end
end
