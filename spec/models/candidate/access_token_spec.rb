require "rails_helper"

RSpec.describe Candidate::AccessToken do
  let(:request_params) do
    {
      email: "test@example.com",
      first_name: "First Name",
      last_name: "Last name",
      date_of_birth: "2000-01-01",
    }
  end
  let(:crm_client) { instance_double(CRM::Client) }
  let(:candidate_resource) do
    instance_double(CRM::Adapters::GetIntoTeaching::Resources::CandidatesResource)
  end

  subject do
    described_class.new(client: crm_client, request_params:)
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
  end

  describe "#create" do
    before do
      allow(crm_client).to receive(:candidates).and_return(candidate_resource)
      allow(candidate_resource).to receive(:create_access_token).and_return(true)
    end

    context "when valid" do
      it "calls the CRM client with the camelized body" do
        subject.create
        expect(candidate_resource).to have_received(:create_access_token) do |body|
          expect(body).to include(
            "email" => "test@example.com",
            "firstName" => "First Name",
            "lastName" => "Last name",
            "dateOfBirth" => Date.new(2000, 1, 1),
          )
        end
      end

      it "returns the CRM response" do
        allow(candidate_resource).to receive(:create_access_token).and_return(true)
        expect(subject.create).to be(true)
      end
    end

    context "when invalid" do
      let(:request_params) { {} }

      it "returns false without calling the CRM client" do
        subject.create
        expect(candidate_resource).not_to have_received(:create_access_token)
      end

      it "populates errors" do
        subject.create
        expect(subject.errors).not_to be_empty
      end
    end
  end

  describe "body" do
    it "camelizes attribute keys" do
      body = subject.send(:body)

      expect(body).to include(
        "email" => "test@example.com",
        "firstName" => "First Name",
        "lastName" => "Last name",
        "dateOfBirth" => Date.new(2000, 1, 1),
      )
    end
  end
end
