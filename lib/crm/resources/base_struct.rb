require "dry-struct"
require "dry-types"

module CRM
  module Resources
    class BaseStruct < Dry::Struct
      Types = Dry::Types()

      def self.new(input)
        filtered = input.is_a?(Hash) ? input.slice(*attribute_names.map(&:to_sym)) : input
        attribute_names.each { |name| filtered[name.to_sym] = nil unless filtered.key?(name.to_sym) }
        super(filtered)
      end
    end
  end
end
