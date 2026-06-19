require "rails_helper"

RSpec.describe GetIntoTeaching::ExchangeAccessToken do
  let(:request_params) do
    {
      access_token: "abc123",
      email: "test@example.com",
      first_name: "First Name",
      last_name: "Last name",
      date_of_birth: "2000-01-01",
      reference: "ref",
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
    it { is_expected.to validate_presence_of(:access_token) }
    it { is_expected.to validate_presence_of(:email) }
  end

  describe "#call" do
    before do
      allow(crm_client).to receive(:get_into_teaching).and_return(get_into_teaching_resource)
      allow(get_into_teaching_resource).to receive(:exchange_access_token).and_return(true)
    end

    context "when valid" do
      it "calls the CRM client with the token and camelized body" do
        subject.call
        expect(get_into_teaching_resource).to have_received(:exchange_access_token) do |token, body|
          expect(token).to eq("abc123")
          expect(body).to include(
            "email" => "test@example.com",
            "firstName" => "First Name",
            "lastName" => "Last name",
            "dateOfBirth" => Date.new(2000, 1, 1),
          )
        end
      end

      it "excludes access_token from the body" do
        subject.call
        expect(get_into_teaching_resource).to have_received(:exchange_access_token) do |_token, body|
          expect(body).not_to have_key("accessToken")
        end
      end

      it "returns the CRM response" do
        allow(get_into_teaching_resource).to receive(:exchange_access_token).and_return(true)
        expect(subject.call).to be(true)
      end
    end

    context "when invalid" do
      let(:request_params) { {} }

      it "returns false without calling the CRM client" do
        subject.call
        expect(get_into_teaching_resource).not_to have_received(:exchange_access_token)
      end

      it "populates errors" do
        subject.call
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

    it "excludes access_token" do
      body = subject.send(:body)
      expect(body).not_to have_key("accessToken")
    end
  end
end
