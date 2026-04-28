# frozen_string_literal: true

require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::LookUpItemsResource do
  let(:client) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }

  subject(:resource) { described_class.new(client) }

  describe "#countries" do
    it "returns a GIT LookUpItems::CountriesResource" do
      expect(resource.countries).to be_a(CRM::Adapters::GetIntoTeaching::Resources::LookUpItems::CountriesResource)
    end
  end
end
