require "rails_helper"

RSpec.describe CRM::Resources::CallbackBookingQuotaResource do
  it "can be instantiated with id and value" do
    instance = described_class.new(
      id: "abc-123",
      time_slot: "9:30am - 10am",
      day: "Thursday 30 April",
      start_at: "2026-04-30T08:30:00Z",
      end_at: "2026-04-30T09:00:00Z",
      number_of_bookings: 0,
      quota: 20,
      is_available: true,
    )

    expect(instance.id).to eq("abc-123")
    expect(instance.time_slot).to eq("9:30am - 10am")
    expect(instance.day).to eq("Thursday 30 April")
    expect(instance.start_at).to eq("2026-04-30T08:30:00Z")
    expect(instance.end_at).to eq("2026-04-30T09:00:00Z")
    expect(instance.number_of_bookings).to eq(0)
    expect(instance.quota).to eq(20)
    expect(instance.is_available).to eq(true)
  end

  it "raises ArgumentError when required fields are missing" do
    expect { described_class.new(id: "abc-123") }
      .to raise_error(ArgumentError)
  end

  it "considers two instances with identical fields equal" do
    a  = described_class.new(
      id: "abc-123",
      time_slot: "9:30am - 10am",
      day: "Thursday 30 April",
      start_at: "2026-04-30T08:30:00Z",
      end_at: "2026-04-30T09:00:00Z",
      number_of_bookings: 0,
      quota: 20,
      is_available: true,
      )
    b = described_class.new(
      id: "abc-123",
      time_slot: "9:30am - 10am",
      day: "Thursday 30 April",
      start_at: "2026-04-30T08:30:00Z",
      end_at: "2026-04-30T09:00:00Z",
      number_of_bookings: 0,
      quota: 20,
      is_available: true,
      )
    expect(a).to eq(b)
  end
end
