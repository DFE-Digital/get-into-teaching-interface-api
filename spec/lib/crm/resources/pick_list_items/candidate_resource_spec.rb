# frozen_string_literal: true

require "rails_helper"

RSpec.describe CRM::Resources::PickListItems::CandidateResource do
  subject(:resource) { described_class.new }

  describe "#initial_teacher_training_years" do
    it "raises NotImplementedError" do
      expect { resource.initial_teacher_training_years }.to raise_error(NotImplementedError)
    end
  end
end
