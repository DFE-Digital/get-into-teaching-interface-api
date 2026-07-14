module CRM
  module Resources
    class CallbackBookingQuotaResource < BaseStruct
      attribute :id,           Types::String
      attribute :time_slot,    Types::String
      attribute :day,          Types::String
      attribute :start_at,     Types::String
      attribute :end_at,       Types::String
      attribute :number_of_bookings, Types::Integer
      attribute :quota,        Types::Integer
      attribute :is_available, Types::Params::Bool
    end
  end
end
