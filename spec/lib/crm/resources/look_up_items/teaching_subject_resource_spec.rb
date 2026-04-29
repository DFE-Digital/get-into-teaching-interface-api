require "rails_helper"

RSpec.describe CRM::Resources::LookUpItems::TeachingSubjectResource do
  it "can be instantiated with id and value" do
    country = described_class.new(id: "abc-123", value: "United Kingdom")

    expect(country.id).to eq("abc-123")
    expect(country.value).to eq("United Kingdom")
  end

  it "raises ArgumentError when required fields are missing" do
    expect { described_class.new(id: "abc-123") }
      .to raise_error(ArgumentError)
  end

  it "considers two instances with identical fields equal" do
    a = described_class.new(id: "x", value: "France")
    b = described_class.new(id: "x", value: "France")

    expect(a).to eq(b)
  end
end
