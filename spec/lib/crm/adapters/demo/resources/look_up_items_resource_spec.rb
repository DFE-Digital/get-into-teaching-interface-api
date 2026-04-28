# frozen_string_literal: true

require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::LookUpItemsResource do
  subject(:resource) { described_class.new }

  describe "#countries" do
    it "returns a Demo LookUpItems::CountriesResource" do
      expect(resource.countries).to be_a(CRM::Adapters::Demo::Resources::LookUpItems::CountriesResource)
    end
  end
end
