require "rails_helper"

RSpec.describe GetIntoTeaching::Callback do
  let(:request_params) do
    {
      email: "test@example.com",
      first_name: "First Name",
      last_name: "Last Name",
      address_telephone: "07735 111111",
      phone_call_scheduled_at: "2026-06-16T14:00:00Z",
      talking_points: "I would like to discuss teaching as a career.",
      accepted_policy_id: "4872c8ed-0229-f111-8342-7c1e5285e3ab",
      candidate_id: "d85a2f0b-290f-4931-98e2-e7d817ac38f3",
    }
  end
  let(:crm_client) { instance_double(CRM::Client) }
  let(:get_into_teaching_resource) do
    instance_double(CRM::Adapters::GetIntoTeaching::Resources::GetIntoTeachingResource)
  end

  subject do
    described_class.new(client: crm_client, request_params:)
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:address_telephone) }
    it { is_expected.to validate_presence_of(:phone_call_scheduled_at) }
    it { is_expected.to validate_presence_of(:talking_points) }
    it { is_expected.to validate_presence_of(:accepted_policy_id) }
  end

  describe "#create" do
    before do
      allow(crm_client).to receive(:get_into_teaching).and_return(get_into_teaching_resource)
      allow(get_into_teaching_resource).to receive(:create_callback).and_return(true)
    end

    context "when valid" do
      it "calls the CRM client with the camelized body" do
        subject.create
        expect(get_into_teaching_resource).to have_received(:create_callback) do |body|
          expect(body).to include(
            "email" => "test@example.com",
            "firstName" => "First Name",
            "lastName" => "Last Name",
            "addressTelephone" => "07735 111111",
            "talkingPoints" => "I would like to discuss teaching as a career.",
            "acceptedPolicyId" => "4872c8ed-0229-f111-8342-7c1e5285e3ab",
            "candidateId" => "d85a2f0b-290f-4931-98e2-e7d817ac38f3",
          )
        end
      end

      it "returns the CRM response" do
        allow(get_into_teaching_resource).to receive(:create_callback).and_return(true)
        expect(subject.create).to be(true)
      end
    end

    context "when invalid" do
      let(:request_params) { {} }

      it "returns false without calling the CRM client" do
        subject.create
        expect(get_into_teaching_resource).not_to have_received(:create_callback)
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
        "lastName" => "Last Name",
        "addressTelephone" => "07735 111111",
        "phoneCallScheduledAt" => "2026-06-16T14:00:00Z",
        "talkingPoints" => "I would like to discuss teaching as a career.",
        "acceptedPolicyId" => "4872c8ed-0229-f111-8342-7c1e5285e3ab",
        "candidateId" => "d85a2f0b-290f-4931-98e2-e7d817ac38f3",
      )
    end
  end
end
