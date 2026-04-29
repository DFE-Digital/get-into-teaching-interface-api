require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Resources::PickListItemsResource do
  let(:client) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }

  subject(:resource) { described_class.new(client) }

  describe "#candidate" do
    it "returns a GIT PickListItems::CandidateResource" do
      expect(resource.candidate).to be_a(CRM::Adapters::GetIntoTeaching::Resources::PickListItems::CandidateResource)
    end
  end
end
