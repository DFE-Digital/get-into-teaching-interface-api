module CRM
  module Resources
    module LookUpItems
      class LookUpItemResource < BaseStruct
        attribute :id, Types::String
        attribute :value, Types::String
      end
    end
  end
end
