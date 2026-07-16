require "rails_helper"

RSpec.describe CRM::Resources::TeachingEvents::BuildingResource do
  it "can be instantiated with id and value" do
    instance = described_class.new(
      venue: "The Open University in Wales",
      address_line1: "Custom House Street",
      address_line2: nil,
      address_line3: nil,
      address_city: "Cardiff",
      address_postcode: "CF10 1AP",
      image_url: nil,
      id: "3290fb7f-93b4-eb11-8236-000d3a26ba1b"
    )

    expect(instance.id).to eq("3290fb7f-93b4-eb11-8236-000d3a26ba1b")
    expect(instance.venue).to eq("The Open University in Wales")
    expect(instance.address_line1).to eq("Custom House Street")
    expect(instance.address_line2).to be_nil
    expect(instance.address_line3).to be_nil
    expect(instance.address_city).to eq("Cardiff")
    expect(instance.address_postcode).to eq("CF10 1AP")
    expect(instance.image_url).to be_nil
  end

  it "raises Dry::Struct::Error when required fields are missing" do
    expect { described_class.new(id: "abc-123") }
      .to raise_error(Dry::Struct::Error)
  end

  it "considers two instances with identical fields equal" do
    a = described_class.new(
      venue: "The Open University in Wales",
      address_line1: "Custom House Street",
      address_line2: nil,
      address_line3: nil,
      address_city: "Cardiff",
      address_postcode: "CF10 1AP",
      image_url: nil,
      id: "3290fb7f-93b4-eb11-8236-000d3a26ba1b"
    )
    b = described_class.new(
      venue: "The Open University in Wales",
      address_line1: "Custom House Street",
      address_line2: nil,
      address_line3: nil,
      address_city: "Cardiff",
      address_postcode: "CF10 1AP",
      image_url: nil,
      id: "3290fb7f-93b4-eb11-8236-000d3a26ba1b"
    )

    expect(a).to eq(b)
  end
end
