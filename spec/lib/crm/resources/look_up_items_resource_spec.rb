# frozen_string_literal: true

require "rails_helper"

RSpec.describe CRM::Resources::LookUpItemsResource do
  subject(:resource) { described_class.new }

  describe "#countries" do
    it "raises NotImplementedError" do
      expect { resource.countries }.to raise_error(NotImplementedError)
    end
  end

  describe "#degree_countries" do
    it "raises NotImplementedError" do
      expect { resource.degree_countries }.to raise_error(NotImplementedError)
    end
  end

  describe "#teaching_subjects" do
    it "raises NotImplementedError" do
      expect { resource.teaching_subjects }.to raise_error(NotImplementedError)
    end
  end
end
