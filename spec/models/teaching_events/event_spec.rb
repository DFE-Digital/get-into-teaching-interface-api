require "rails_helper"

RSpec.describe TeachingEvents::Event do
  let(:request_params) do
    {
      type_id: 222_750_000,
      status_id: 222_750_000,
      readable_id: "123",
      name: "Test Event",
      start_at: "2026-07-01T09:00:00Z",
      end_at: "2026-07-01T17:00:00Z",
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
    it { is_expected.to validate_presence_of(:type_id) }
    it { is_expected.to validate_presence_of(:status_id) }
    it { is_expected.to validate_presence_of(:readable_id) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:start_at) }
    it { is_expected.to validate_presence_of(:end_at) }
  end

  describe "#create" do
    before do
      allow(crm_client).to receive(:teaching_events).and_return(teaching_events_resource)
      allow(teaching_events_resource).to receive(:create).and_return(true)
    end

    context "when valid" do
      it "calls the CRM client with the camelized body" do
        subject.create
        expect(teaching_events_resource).to have_received(:create) do |body|
          expect(body).to include(
            "typeId" => 222_750_000,
            "statusId" => 222_750_000,
            "readableId" => "123",
            "name" => "Test Event",
            "startAt" => "2026-07-01T09:00:00Z",
            "endAt" => "2026-07-01T17:00:00Z",
          )
        end
      end

      it "returns the response from the CRM client" do
        allow(teaching_events_resource).to receive(:create).and_return(true)
        expect(subject.create).to be(true)
      end
    end

    context "when invalid" do
      let(:request_params) { {} }

      it "returns false without calling the CRM client" do
        subject.create
        expect(teaching_events_resource).not_to have_received(:create)
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
        "typeId" => 222_750_000,
        "statusId" => 222_750_000,
        "readableId" => "123",
        "name" => "Test Event",
        "startAt" => "2026-07-01T09:00:00Z",
        "endAt" => "2026-07-01T17:00:00Z",
      )
    end
  end
end
