require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::LookUpItems::TeachingSubjectsResource do
  let(:base_url) { "https://test.example.com" }
  let(:client) { CRM::Adapters::GetIntoTeaching::Client.new(base_url: base_url, api_key: "test-key") }

  subject(:resource) { described_class.new(client) }

  describe "#all" do
    before do
      stub_request(:get, "#{base_url}/api/lookup_items/teaching_subjects")
        .to_return(
          status: 200,
          body: [
            { "id" => "abc-123", "value" => "Art" },
            { "id" => "def-456", "value" => "Art & Design" },
          ].to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "returns CRM::Resources::LookUpItems::TeachingSubjectResource instances" do
      expect(resource.all).to all(be_a(CRM::Resources::LookUpItems::TeachingSubjectResource))
    end

    it "maps API response attributes to snake_case" do
      teaching_subject = resource.all.first

      expect(teaching_subject.id).to eq("abc-123")
      expect(teaching_subject.value).to eq("Art")
    end

    context "when the API returns an error" do
      before do
        stub_request(:get, "#{base_url}/api/lookup_items/teaching_subjects")
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
