require "json"

class JsonParser
  def self.parse(value)
    result = JSON.parse(value)

    result if result.is_a?(Hash) || result.is_a?(Array)
  rescue JSON::ParserError, TypeError
    nil
  end
end
