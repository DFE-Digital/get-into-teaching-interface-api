require "rails_helper"

RSpec.describe JsonParser do
  describe ".parse" do
    it "returns a hash from valid JSON object" do
      result = described_class.parse('{"key":"value"}')
      expect(result).to eq("key" => "value")
    end

    it "returns an array from valid JSON array" do
      result = described_class.parse("[1, 2, 3]")
      expect(result).to eq([ 1, 2, 3 ])
    end

    it "returns nil for a JSON string primitive" do
      result = described_class.parse('"hello"')
      expect(result).to be_nil
    end

    it "returns nil for a JSON number primitive" do
      result = described_class.parse("42")
      expect(result).to be_nil
    end

    it "returns nil for a JSON boolean primitive" do
      result = described_class.parse("true")
      expect(result).to be_nil
    end

    it "returns nil for JSON null" do
      result = described_class.parse("null")
      expect(result).to be_nil
    end

    it "returns nil for invalid JSON" do
      result = described_class.parse("not-json")
      expect(result).to be_nil
    end

    it "returns nil for an empty string" do
      result = described_class.parse("")
      expect(result).to be_nil
    end

    it "returns nil when given nil" do
      result = described_class.parse(nil)
      expect(result).to be_nil
    end
  end
end
