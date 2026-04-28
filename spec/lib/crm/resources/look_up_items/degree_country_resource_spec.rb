# frozen_string_literal: true

require "rails_helper"

RSpec.describe CRM::Resources::LookUpItems::DegreeCountryResource do
  it "can be instantiated with id, value, and iso_code" do
    country = described_class.new(id: "abc-123", value: "United Kingdom", iso_code: "GB")

    expect(country.id).to eq("abc-123")
    expect(country.value).to eq("United Kingdom")
    expect(country.iso_code).to eq("GB")
  end

  it "raises ArgumentError when required fields are missing" do
    expect { described_class.new(id: "abc-123", value: "United Kingdom") }
      .to raise_error(ArgumentError)
  end

  it "considers two instances with identical fields equal" do
    a = described_class.new(id: "x", value: "France", iso_code: "FR")
    b = described_class.new(id: "x", value: "France", iso_code: "FR")

    expect(a).to eq(b)
  end
end
