require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::TeacherTrainingAdviser::Resource do
  let(:base_url) { "https://test.example.com" }
  let(:api_key) { "test-key" }
  let(:client) { CRM::Adapters::GetIntoTeaching::Client.new(base_url:, api_key:) }

  subject(:resource) { described_class.new(client) }

  describe "#candidates" do
    let(:body) { { email: "test@example.com", firstName: "John" } }

    before do
      stub_request(:post, "#{base_url}/api/teacher_training_adviser/candidates")
        .with(body: body.to_json)
        .to_return(
          status: 200,
          body: {}.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "sends a POST request with the given body" do
      resource.candidates(body)
      expect(
        a_request(:post, "#{base_url}/api/teacher_training_adviser/candidates")
          .with(body: body.to_json)
      ).to have_been_made.once
    end

    it "returns a Faraday response" do
      expect(resource.candidates(body)).to be_a(Faraday::Response)
    end

    context "when the API returns an error" do
      before do
        stub_request(:post, "#{base_url}/api/teacher_training_adviser/candidates")
          .with(body: body.to_json)
          .to_return(status: 401, body: { "error" => "Unauthorized" }.to_json,
                     headers: { "Content-Type" => "application/json" })
      end

      it "raises Resource::Error" do
        expect { resource.candidates(body) }
          .to raise_error(CRM::Adapters::GetIntoTeaching::Resource::Error, /valid authentication credentials/)
      end
    end
  end
end
