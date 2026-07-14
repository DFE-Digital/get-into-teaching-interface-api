require "rails_helper"

RSpec.describe CRM::Resources::BaseStruct do
  let(:test_struct) do
    klass = Class.new(described_class)
    klass.attribute(:id, CRM::Resources::BaseStruct::Types::String)
    klass.attribute(:name, CRM::Resources::BaseStruct::Types::String)
    klass
  end

  describe "instantiation" do
    it "builds an instance with recognised attributes" do
      instance = test_struct.new(id: "abc-123", name: "Example")

      expect(instance.id).to eq("abc-123")
      expect(instance.name).to eq("Example")
    end

    it "strips unknown keys silently" do
      instance = test_struct.new(id: "abc-123", name: "Example", extra: "ignored")

      expect(instance.to_h).to eq(id: "abc-123", name: "Example")
    end
  end
end
