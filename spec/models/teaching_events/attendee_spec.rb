require "rails_helper"

RSpec.describe TeachingEvents::Attendee do
  let(:request_params) do
    {
      event_id: "event-123",
      email: "test@example.com",
      first_name: "John",
      last_name: "Doe",
      accepted_policy_id: "policy-1",
    }
  end
  let(:crm_client) { instance_double(CRM::Client) }
  let(:teaching_events_resource) do
    instance_double(CRM::Adapters::GetIntoTeaching::Resources::TeachingEventsResource)
  end

  subject do
    described_class.new(client: crm_client, request_params:)
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:event_id) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:accepted_policy_id) }
  end

  describe "#create" do
    before do
      allow(crm_client).to receive(:teaching_events).and_return(teaching_events_resource)
      allow(teaching_events_resource).to receive(:create_attendee).and_return(true)
    end

    context "when valid" do
      it "calls the CRM client with the camelized body" do
        subject.create
        expect(teaching_events_resource).to have_received(:create_attendee) do |body|
          expect(body).to include(
            "eventId" => "event-123",
            "email" => "test@example.com",
            "firstName" => "John",
            "lastName" => "Doe",
            "acceptedPolicyId" => "policy-1",
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
        expect(teaching_events_resource).not_to have_received(:create_attendee)
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
        "eventId" => "event-123",
        "email" => "test@example.com",
        "firstName" => "John",
        "lastName" => "Doe",
        "acceptedPolicyId" => "policy-1",
      )
    end
  end
end
