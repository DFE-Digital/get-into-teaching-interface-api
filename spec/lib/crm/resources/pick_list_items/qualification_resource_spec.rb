require "rails_helper"

RSpec.describe CRM::Resources::PickListItems::QualificationResource do
  subject(:resource) { described_class.new }

  describe "#degree_statuses" do
    it "raises NotImplementedError" do
      expect { resource.degree_statuses }.to raise_error(NotImplementedError)
    end
  end
end
