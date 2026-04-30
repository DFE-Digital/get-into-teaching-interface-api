module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
          class CallbackBookingQuotasResource < CRM::Adapters::GetIntoTeaching::Resource
            def all(**params)
              response = get_request("/api/callback_booking_quotas", params: params)
              response_to_collection(response, type: CRM::Resources::CallbackBookingQuotaResource)
            end
          end
      end
    end
  end
end
