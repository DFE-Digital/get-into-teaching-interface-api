require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::SchoolsExperienceResource do
  subject(:resource) { described_class.new }

  describe "#create_candidate" do
    let(:result) { resource.create_candidate({}) }

    it "returns a Data object with a body" do
      expect(result).to respond_to(:body)
    end

    it "returns a hash from body" do
      expect(result.body).to be_a(Hash)
    end

    it "includes all sign-up fields" do
      expect(result.body).to include(
        "email" => "johndoe@example.com",
        "firstName" => "John",
        "lastName" => "Doe",
        "preferredTeachingSubjectId" => "subject-1",
        "addressLine1" => "123 Main St",
        "addressCity" => "London",
        "addressStateOrProvince" => "London",
        "addressPostcode" => "SW1A 1AA",
        "telephone" => "01234567890",
        "hasDbsCertificate" => true,
        "acceptedPolicyId" => "policy-1",
        "candidateId" => "abc-123",
      )
    end
  end
end
