require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resource do
  let(:concrete_resource) { Class.new(described_class).new(client) }
  let(:client) { instance_double(CRM::Adapters::GetIntoTeaching::Client, connection: connection) }
  let(:connection) { double }

  describe "#handle_response" do
    context "when status is 200" do
      let(:response) { double(status: 200, body: []) }

      it "returns the response" do
        expect(concrete_resource.handle_response(response)).to eq(response)
      end
    end

    {
      400 => "Your request was malformed",
      401 => "You did not supply valid authentication credentials",
      403 => "You are not allowed to perform that action",
      500 => "We were unable to perform the request due to server-side problems",
      503 => "We were unable to perform the request, due to ongoing maintenance",
    }.each do |status, message|
      context "when status is #{status}" do
        let(:response) { double(status: status, body: { "error" => "details" }) }

        it "raises Resource::Error" do
          expect { concrete_resource.handle_response(response) }
            .to raise_error(described_class::Error, /#{Regexp.escape(message)}/)
        end
      end
    end

    context "when status is 404" do
      let(:response) { double(status: 404, body: { "error" => "details" }) }

      it "raises Resource::NotFoundError specifically" do
        expect { concrete_resource.handle_response(response) }
          .to raise_error(described_class::NotFoundError, /No results were found/)
      end
    end

    context "when status is 422" do
      let(:response) { double(status: 422, body: { "errors" => [ "invalid field" ] }) }

      it "raises Resource::Error" do
        expect { concrete_resource.handle_response(response) }
          .to raise_error(described_class::Error, /Your request was well-formed but contained invalid data/)
      end
    end
  end

  describe "#response_to_collection" do
    let(:response) do
      double(body: [
        { "Id" => "abc-123", "Value" => "United Kingdom", "IsoCode" => "GB" },
      ])
    end

    it "returns an array of the given type" do
      result = concrete_resource.response_to_collection(response, type: CRM::Resources::LookUpItems::CountryResource)

      expect(result).to contain_exactly(
        CRM::Resources::LookUpItems::CountryResource.new(id: "abc-123", value: "United Kingdom", iso_code: "GB")
      )
    end

    it "transforms camelCase keys to snake_case" do
      result = concrete_resource.response_to_collection(response, type: CRM::Resources::LookUpItems::CountryResource)
      country = result.first

      expect(country.iso_code).to eq("GB")
    end

    context "when response body is nil" do
      let(:response) { double(body: nil) }

      it "returns an empty array" do
        result = concrete_resource.response_to_collection(response, type: CRM::Resources::LookUpItems::CountryResource)

        expect(result).to be_empty
      end
    end
  end

  describe "#get_request" do
    let(:response) { double(status: 200, body: []) }

    before { allow(connection).to receive(:get).and_return(response) }

    it "delegates to the connection" do
      concrete_resource.get_request("/api/test")

      expect(connection).to have_received(:get).with("/api/test", {}, {})
    end

    it "returns the response" do
      expect(concrete_resource.get_request("/api/test")).to eq(response)
    end
  end
end
