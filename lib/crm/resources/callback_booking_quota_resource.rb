module CRM
  module Resources
    CallbackBookingQuotaResource = Data.define(
      :id,
      :time_slot,
      :day,
      :start_at,
      :end_at,
      :number_of_bookings,
      :quota,
      :is_available,
    )
  end
end
