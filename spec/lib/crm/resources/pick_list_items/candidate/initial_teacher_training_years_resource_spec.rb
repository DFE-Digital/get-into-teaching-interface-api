# frozen_string_literal: true

require "rails_helper"

RSpec.describe CRM::Resources::PickListItems::Candidate::InitialTeacherTrainingYearsResource do
  subject(:resource) { described_class.new }

  describe "#all" do
    it "raises NotImplementedError" do
      expect { resource.all }.to raise_error(NotImplementedError)
    end
  end
end
