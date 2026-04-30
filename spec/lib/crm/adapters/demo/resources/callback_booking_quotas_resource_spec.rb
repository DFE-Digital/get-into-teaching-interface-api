require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::CallbackBookingQuotasResource do
  subject(:resource) { described_class.new }

  describe "#all" do
    it "returns an array" do
      expect(resource.all).to be_an(Array)
    end

    it "returns CallbackBookingQuotaResource instances" do
      expect(resource.all).to all(be_a(CRM::Resources::CallbackBookingQuotaResource))
    end

    it "returns entries with id and value readers" do
      item = resource.all.first

      expect(item).to respond_to(
                        :id,
                        :time_slot,
                        :day,
                        :start_at,
                        :end_at,
                        :number_of_bookings,
                        :quota,
                        :is_available,
                      )
    end
  end
end
