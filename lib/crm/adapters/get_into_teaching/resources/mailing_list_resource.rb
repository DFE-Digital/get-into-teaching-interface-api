module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class MailingListResource < CRM::Adapters::GetIntoTeaching::Resource
          def create_member(body)
            post_request("/api/mailing_list/members", body:)
          end
        end
      end
    end
  end
end
