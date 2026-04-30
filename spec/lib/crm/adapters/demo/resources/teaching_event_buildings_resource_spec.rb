require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::TeachingEventBuildingsResource do
  subject(:resource) { described_class.new }

  describe "#all" do
    it "returns an array" do
      expect(resource.all).to be_an(Array)
    end

    it "returns TeachingEventBuildingResource instances" do
      expect(resource.all).to all(be_a(CRM::Resources::TeachingEventBuildingResource))
    end

    it "returns entries with id and value readers" do
      item = resource.all.first

      expect(item).to respond_to(
      :venue,
      :address_line1,
      :address_line2,
      :address_line3,
      :address_city,
      :address_postcode,
      :image_url,
      :id,
                      )
    end
  end
end
