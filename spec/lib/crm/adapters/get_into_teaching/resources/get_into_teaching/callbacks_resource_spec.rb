require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::GetIntoTeaching::CallbacksResource do
  let(:base_url) { "https://test.example.com" }
  let(:client) { CRM::Adapters::GetIntoTeaching::Client.new(base_url: base_url, api_key: "test-key") }

  subject(:resource) { described_class.new(client) }

  describe "#create" do
    before do
      stub_request(:post, "#{base_url}/api/get_into_teaching/callbacks")
        .to_return(
          status: 200,
          body: [
            { "Id" => "abc-123", "Value" => "Example 1" },
            { "Id" => "def-456", "Value" => "Example 2" },
          ].to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "returns CallbackResource instances" do
      expect(resource.create).to all(be_a(CRM::Resources::GetIntoTeaching::CallbackResource))
    end

    it "maps API response attributes to snake_case" do
      item = resource.create.first

      expect(item.id).to eq("abc-123")
      expect(item.value).to eq("Example 1")
    end

    context "when the API returns an error" do
      before do
        stub_request(:post, "#{base_url}/api/get_into_teaching/callbacks")
          .to_return(status: 401, body: { "error" => "Unauthorized" }.to_json,
                     headers: { "Content-Type" => "application/json" })
      end

      it "raises Resource::Error" do
        expect { resource.create }
          .to raise_error(CRM::Adapters::GetIntoTeaching::Resource::Error, /valid authentication credentials/)
      end
    end
  end
end
