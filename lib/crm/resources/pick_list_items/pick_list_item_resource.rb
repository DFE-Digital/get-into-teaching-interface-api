module CRM
  module Resources
    module PickListItems
      class PickListItemResource < BaseStruct
        attribute :id, Types::Integer
        attribute :value, Types::String
      end
    end
  end
end
