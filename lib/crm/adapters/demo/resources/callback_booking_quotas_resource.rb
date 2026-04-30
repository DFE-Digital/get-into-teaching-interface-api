module CRM
  module Adapters
    module Demo
      module Resources
          class CallbackBookingQuotasResource < CRM::Resources::CallbackBookingQuotasResource
            def all(*)
              [
                CRM::Resources::CallbackBookingQuotaResource.new(
                  id: '27d74cc7-7fa3-f011-bbd3-000d3a384b51',
                  time_slot: "9:30am - 10am",
                  day: "Thursday 30 April",
                  start_at: "2026-04-30T08:30:00Z",
                  end_at: "2026-04-30T09:00:00Z",
                  number_of_bookings: 0,
                  quota: 20,
                  is_available: true,
                ),
                CRM::Resources::CallbackBookingQuotaResource.new(
                  id: "29d74cc7-7fa3-f011-bbd3-000d3a384b51",
                  time_slot: "10am - 10:30am",
                  day: "Thursday 30 April",
                  start_at: "2026-04-30T09:00:00Z",
                  end_at: "2026-04-30T09:30:00Z",
                  number_of_bookings: 0,
                  quota: 20,
                  is_available: true,
                ),
              ]
            end
        end
      end
    end
  end
end
