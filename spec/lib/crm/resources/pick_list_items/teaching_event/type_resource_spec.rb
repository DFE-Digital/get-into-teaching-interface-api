require "rails_helper"

RSpec.describe CRM::Resources::PickListItems::TeachingEvent::TypeResource do
  it "can be instantiated with id and value" do
    instance = described_class.new(id: 123, value: "Example")

    expect(instance.id).to eq(123)
    expect(instance.value).to eq("Example")
  end

  it "raises Dry::Struct::Error when required fields are missing" do
    expect { described_class.new(id: 123) }
      .to raise_error(Dry::Struct::Error)
  end

  it "considers two instances with identical fields equal" do
    a = described_class.new(id: 1, value: "Example")
    b = described_class.new(id: 1, value: "Example")

    expect(a).to eq(b)
  end
end
