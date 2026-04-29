# frozen_string_literal: true

require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::PickListItemsResource do
  subject(:resource) { described_class.new }

  describe "#candidate" do
    it "returns a Demo PickListItems::CandidateResource" do
      expect(resource.candidate).to be_a(CRM::Adapters::Demo::Resources::PickListItems::CandidateResource)
    end
  end
end
