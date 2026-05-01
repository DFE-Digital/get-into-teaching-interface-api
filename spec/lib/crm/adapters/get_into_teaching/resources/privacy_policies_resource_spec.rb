require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::PrivacyPoliciesResource do
  let(:base_url) { "https://test.example.com" }
  let(:client) { CRM::Adapters::GetIntoTeaching::Client.new(base_url: base_url, api_key: "test-key") }

  subject(:resource) { described_class.new(client) }

  describe "#find" do
    before do
      stub_request(:get, "#{base_url}/api/privacy_policies/some-id")
        .to_return(
          status: 200,
          body:
            { "Id" => "abc-123", "Text" => "Example 1", "CreatedAt" => '2026-03-26T11:00:01' }
          .to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "returns an PrivacyPolicyResource instance" do
      expect(resource.find("some-id")).to be_a(CRM::Resources::PrivacyPolicyResource)
    end

    it "maps API response attributes to snake_case" do
      item = resource.find("some-id")

      expect(item.id).to eq("abc-123")
      expect(item.text).to eq("Example 1")
      expect(item.created_at).to eq("2026-03-26T11:00:01")
    end

    context "when the API returns an error" do
      before do
        stub_request(:get, "#{base_url}/api/privacy_policies/some-id")
          .to_return(status: 401, body: { "error" => "Unauthorized" }.to_json,
                     headers: { "Content-Type" => "application/json" })
      end

      it "raises Resource::Error" do
        expect { resource.find("some-id") }
          .to raise_error(CRM::Adapters::GetIntoTeaching::Resource::Error, /valid authentication credentials/)
      end
    end

    context "when the API returns 404" do
      before do
        stub_request(:get, "#{base_url}/api/privacy_policies/some-id")
          .to_return(status: 404, body: { "error" => "Not found" }.to_json,
                     headers: { "Content-Type" => "application/json" })
      end

      it "raises Resource::NotFoundError" do
        expect { resource.find("some-id") }
          .to raise_error(CRM::Adapters::GetIntoTeaching::Resource::NotFoundError)
      end
    end
  end
end
