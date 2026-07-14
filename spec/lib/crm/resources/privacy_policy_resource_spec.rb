require "rails_helper"

RSpec.describe CRM::Resources::PrivacyPolicyResource do
  it "can be instantiated with id and value" do
    instance = described_class.new(id: "abc-123", text: "Example", created_at: "2026-03-26T11:00:01")

    expect(instance.id).to eq("abc-123")
    expect(instance.text).to eq("Example")
    expect(instance.created_at).to eq("2026-03-26T11:00:01")
  end

  it "raises Dry::Struct::Error when required fields are missing" do
    expect { described_class.new(id: "abc-123") }
      .to raise_error(Dry::Struct::Error)
  end

  it "considers two instances with identical fields equal" do
    a = described_class.new(id: "abc-123", text: "Example", created_at: "2026-03-26T11:00:01")
    b = described_class.new(id: "abc-123", text: "Example", created_at: "2026-03-26T11:00:01")

    expect(a).to eq(b)
  end
end
