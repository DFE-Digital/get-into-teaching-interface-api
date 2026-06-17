require "rails_helper"

RSpec.describe MailingList::Member do
  let(:request_params) do
    {
      email: "test@example.com",
      first_name: "John",
      last_name: "Doe",
      accepted_policy_id: "abc-123",
      consideration_journey_stage_id: 222750000,
      preferred_teaching_subject_id: "subject-1",
    }
  end
  let(:crm_client) { instance_double(CRM::Client) }
  let(:mailing_list_resource) do
    instance_double(CRM::Adapters::GetIntoTeaching::Resources::MailingListResource)
  end

  subject do
    described_class.new(client: crm_client, request_params:)
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:accepted_policy_id) }
    it { is_expected.to validate_presence_of(:consideration_journey_stage_id) }
    it { is_expected.to validate_presence_of(:preferred_teaching_subject_id) }
  end

  describe "#create" do
    before do
      allow(crm_client).to receive(:mailing_list).and_return(mailing_list_resource)
      allow(mailing_list_resource).to receive(:create_member).and_return(true)
    end

    context "when valid" do
      it "calls the CRM client with the camelized body" do
        subject.create
        expect(mailing_list_resource).to have_received(:create_member) do |body|
          expect(body).to include(
            "email" => "test@example.com",
            "firstName" => "John",
            "lastName" => "Doe",
            "acceptedPolicyId" => "abc-123",
            "considerationJourneyStageId" => 222750000,
            "preferredTeachingSubjectId" => "subject-1",
          )
        end
      end

      it "returns the CRM response" do
        allow(mailing_list_resource).to receive(:create_member).and_return(true)
        expect(subject.create).to be(true)
      end
    end

    context "when invalid" do
      let(:request_params) { {} }

      it "returns false without calling the CRM client" do
        subject.create
        expect(mailing_list_resource).not_to have_received(:create_member)
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
        "acceptedPolicyId" => "abc-123",
        "considerationJourneyStageId" => 222750000,
        "preferredTeachingSubjectId" => "subject-1",
      )
    end
  end
end
