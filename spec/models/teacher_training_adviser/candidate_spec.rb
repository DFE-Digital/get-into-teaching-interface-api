require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Candidate do
  let(:request_params) do
    {
      email: "test@example.com",
      first_name: "John",
      last_name: "Doe",
      date_of_birth: "1990-01-01",
      accepted_policy_id: "abc-123",
      country_id: "uk",
      type_id: "type-1",
    }
  end
  let(:crm_client) { instance_double(CRM::Client) }
  let(:candidate_resource) do
    instance_double(CRM::Adapters::GetIntoTeaching::Resources::TeacherTrainingAdviser::Resource)
  end

  subject do
    described_class.new(client: crm_client, request_params:)
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:date_of_birth) }
    it { is_expected.to validate_presence_of(:accepted_policy_id) }
    it { is_expected.to validate_presence_of(:country_id) }
    it { is_expected.to validate_presence_of(:type_id) }
  end

  describe "#create" do
    before do
      allow(crm_client).to receive(:teacher_training_adviser).and_return(candidate_resource)
      allow(candidate_resource).to receive(:create_candidate).and_return(true)
    end

    context "when valid" do
      it "calls the CRM client with the camelized body" do
        subject.create
        expect(candidate_resource).to have_received(:create_candidate) do |body|
          expect(body).to include(
            "email" => "test@example.com",
            "firstName" => "John",
            "lastName" => "Doe",
            "dateOfBirth" => Date.new(1990, 1, 1)
          )
        end

        allow(candidate_resource).to receive(:create_candidate).and_return(true)
        expect(subject.create).to be(true)
      end
    end

    context "when invalid" do
      let(:request_params) { {} }

      it "returns false without calling the CRM client" do
        subject.create
        expect(candidate_resource).not_to have_received(:create_candidate)
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
        "firstName" => "John",
        "lastName" => "Doe",
        "dateOfBirth" => Date.new(1990, 1, 1),
        "acceptedPolicyId" => "abc-123",
        "countryId" => "uk",
        "typeId" => "type-1",
      )
    end
  end
end
