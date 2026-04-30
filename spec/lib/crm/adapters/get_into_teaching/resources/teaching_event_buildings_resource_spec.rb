require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::TeachingEventBuildingsResource do
  let(:base_url) { "https://test.example.com" }
  let(:client) { CRM::Adapters::GetIntoTeaching::Client.new(base_url: base_url, api_key: "test-key") }

  subject(:resource) { described_class.new(client) }

  describe "#all" do
    before do
      stub_request(:get, "#{base_url}/api/teaching_event_buildings")
        .to_return(
          status: 200,
          body: [
            {
              "venue": "The Open University in Wales",
              "addressLine1": "Custom House Street",
              "addressLine2": nil,
              "addressLine3": nil,
              "addressCity": "Cardiff",
              "addressPostcode": "CF10 1AP",
              "imageUrl": "https://test.example.com/image.png",
              "id": "3290fb7f-93b4-eb11-8236-000d3a26ba1b",
            },
            {
              "venue": "World Trade Centre -Delhi",
              "addressLine1": "1",
              "addressLine2": "2",
              "addressLine3": "3",
              "addressCity": "Delhi",
              "addressPostcode": "se28 8pt",
              "imageUrl": nil,
              "id": "3ef13d86-9b62-ee11-8df0-6045bd8c543c",
            },
          ].to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "returns TeachingEventBuildingResource instances" do
      expect(resource.all).to all(be_a(CRM::Resources::TeachingEventBuildingResource))
    end

    it "maps API response attributes to snake_case" do
      item = resource.all.first

      expect(item.venue).to eq("The Open University in Wales")
      expect(item.address_line1).to eq("Custom House Street")
      expect(item.address_line2).to eq(nil)
      expect(item.address_line3).to eq(nil)
      expect(item.address_city).to eq("Cardiff")
      expect(item.address_postcode).to eq("CF10 1AP")
      expect(item.image_url).to eq("https://test.example.com/image.png")
      expect(item.id).to eq("3290fb7f-93b4-eb11-8236-000d3a26ba1b")
    end

    context "when the API returns an error" do
      before do
        stub_request(:get, "#{base_url}/api/teaching_event_buildings")
          .to_return(status: 401, body: { "error" => "Unauthorized" }.to_json,
                     headers: { "Content-Type" => "application/json" })
      end

      it "raises Resource::Error" do
        expect { resource.all }
          .to raise_error(CRM::Adapters::GetIntoTeaching::Resource::Error, /valid authentication credentials/)
      end
    end
  end
end
