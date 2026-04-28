# frozen_string_literal: true

require "rails_helper"

RSpec.describe CRM::Adapters::Demo::Resources::LookUpItems::TeachingSubjectsResource do
  subject(:resource) { described_class.new }

  describe "#all" do
    it "returns an array of 2 teaching subjects" do
      expect(resource.all.length).to eq(3)
    end

    it "returns CRM::Resources::LookUpItems::TeachingSubject instances" do
      expect(resource.all).to all(be_a(CRM::Resources::LookUpItems::TeachingSubjectResource))
    end

    it "returns entries with id and value readers" do
      teaching_subject = resource.all.first

      expect(teaching_subject).to respond_to(:id, :value)
    end
  end
end
