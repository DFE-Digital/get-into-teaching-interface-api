require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Client do
  subject(:client) { described_class.new }

  describe "#lookup_items" do
    it "returns a Demo LookUpItemsResource" do
      expect(client.lookup_items).to be_a(CRM::Adapters::Demo::Resources::LookUpItemsResource)
    end
  end

  describe "#pick_list_items" do
    it "returns a Demo PickListItemsResource" do
      expect(client.pick_list_items).to be_a(CRM::Adapters::Demo::Resources::PickListItemsResource)
    end
  end

  describe "#callback_booking_quotas" do
    it "returns a Demo CallbackBookingQuotasResource" do
      expect(client.callback_booking_quotas).to be_a(CRM::Adapters::Demo::Resources::CallbackBookingQuotasResource)
    end
  end

  describe "#privacy_policies" do
    it "returns a Demo PrivacyPoliciesResource" do
      expect(client.privacy_policies).to be_a(CRM::Adapters::Demo::Resources::PrivacyPoliciesResource)
    end
  end
end
