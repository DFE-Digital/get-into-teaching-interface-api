require "rails_helper"

RSpec.describe SchoolsExperience::Candidate do
  let(:request_params) do
    {
      email: "test@example.com",
      first_name: "John",
      last_name: "Doe",
      preferred_teaching_subject_id: "subject-1",
      accepted_policy_id: "policy-1",
      address_line_1: "123 Main St",
      address_city: "London",
      address_state_or_province: "London",
      address_postcode: "SW1A 1AA",
      telephone: "01234567890",
      has_dbs_certificate: true,
    }
  end
  let(:crm_client) { instance_double(CRM::Client) }
  let(:candidate_resource) do
    instance_double(CRM::Adapters::Demo::Resources::SchoolsExperienceResource)
  end

  subject do
    described_class.new(client: crm_client, request_params:)
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:preferred_teaching_subject_id) }
    it { is_expected.to validate_presence_of(:accepted_policy_id) }
    it { is_expected.to validate_presence_of(:address_line_1) }
    it { is_expected.to validate_presence_of(:address_city) }
    it { is_expected.to validate_presence_of(:address_state_or_province) }
    it { is_expected.to validate_presence_of(:address_postcode) }
    it { is_expected.to validate_presence_of(:telephone) }
    it { is_expected.to validate_presence_of(:has_dbs_certificate) }
  end

  describe "#create" do
    before do
      allow(crm_client).to receive(:schools_experience).and_return(candidate_resource)
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
          )
        end
      end

      it "returns the response from the CRM client" do
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
        "preferredTeachingSubjectId" => "subject-1",
        "acceptedPolicyId" => "policy-1",
        "addressLine1" => "123 Main St",
        "addressCity" => "London",
        "addressStateOrProvince" => "London",
        "addressPostcode" => "SW1A 1AA",
        "telephone" => "01234567890",
        "hasDbsCertificate" => true,
      )
    end
  end
end
