module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class MailingListResource < CRM::Adapters::GetIntoTeaching::Resource
          def create_member(body)
            response = post_request("/api/mailing_list/members", body:)
            response_to_type(response, type: CRM::Resources::TeacherTrainingAdviser::DegreeResource)
          end

          def exchange_access_token(token, body)
            response = post_request("/api/mailing_list/members/exchange_access_token/#{token}", body:)
            response_to_type(response, type: CRM::Resources::MailingList::CandidateResource)
          end
        end
      end
    end
  end
end
