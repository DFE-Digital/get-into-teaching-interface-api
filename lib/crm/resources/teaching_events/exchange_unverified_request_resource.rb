module CRM
  module Resources
    module TeachingEvents
      class ExchangeUnverifiedRequestResource < BaseStruct
        attribute :candidate_id, Types::String.optional
        attribute :email,        Types::String
        attribute :first_name,   Types::String.optional
        attribute :last_name,    Types::String.optional
      end
    end
  end
end
