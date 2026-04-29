require "rails_helper"

RSpec.describe CRM::Resources::PickListItems::Candidate::CitizenshipResource do
  it "can be instantiated with id and value" do
    instance = described_class.new(id: "abc-123", value: "Example")

    expect(instance.id).to eq("abc-123")
    expect(instance.value).to eq("Example")
  end

  it "raises ArgumentError when required fields are missing" do
    expect { described_class.new(id: "abc-123") }
      .to raise_error(ArgumentError)
  end

  it "considers two instances with identical fields equal" do
    a = described_class.new(id: "x", value: "Example")
    b = described_class.new(id: "x", value: "Example")

    expect(a).to eq(b)
  end
end
