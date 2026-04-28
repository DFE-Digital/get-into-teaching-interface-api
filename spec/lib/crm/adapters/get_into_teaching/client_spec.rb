# frozen_string_literal: true

require "rails_helper"

RSpec.describe CRM::Adapters::GetIntoTeaching::Client do
  subject(:adapter) { described_class.new }

  describe "#lookup_items" do
    it "returns a GIT LookUpItemsResource" do
      expect(adapter.lookup_items).to be_a(CRM::Adapters::GetIntoTeaching::Resources::LookUpItemsResource)
    end
  end

  describe "#lookup_items.countries", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/countries" } do
    subject(:result) { adapter.lookup_items.countries.all }

    it "returns CountryResource instances" do
      expect(result).to all(be_a(CRM::Resources::LookUpItems::CountryResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
        CRM::Resources::LookUpItems::CountryResource.new(
          id: "fdf3c2e6-74f9-e811-a97a-000d3a2760f2",
          value: "Afghanistan",
          iso_code: "AF"
        )
      )
    end

    it "handles entries with a null iso_code" do
      unknown = result.find { |c| c.value == "Unknown" }

      expect(unknown).not_to be_nil
      expect(unknown.iso_code).to be_nil
    end
  end

  describe "#lookup_items.degree_countries", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/degree_countries" } do
    subject(:result) { adapter.lookup_items.degree_countries.all }

    it "returns CountryResource instances" do
      expect(result).to all(be_a(CRM::Resources::LookUpItems::DegreeCountryResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
                                CRM::Resources::LookUpItems::DegreeCountryResource.new(
                                  id: "6f9e7b81-e44d-f011-877a-00224886d23e",
                                  value: "Another Country",
                                  iso_code: nil
                                )
                              )
    end

    it "handles entries with a null iso_code" do
      unknown = result.find { |c| c.value == "Another Country" }

      expect(unknown).not_to be_nil
      expect(unknown.iso_code).to be_nil
    end
  end

  describe "#lookup_items.teaching_subjects", vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/teaching_subjects" } do
    subject(:result) { adapter.lookup_items.teaching_subjects.all }

    it "returns TeachingSubjectResource instances" do
      expect(result).to all(be_a(CRM::Resources::LookUpItems::TeachingSubjectResource))
    end

    it "deserializes the first entry correctly" do
      expect(result.first).to eq(
                                CRM::Resources::LookUpItems::TeachingSubjectResource.new(
                                  id: "6b793433-cd1f-e911-a979-000d3a20838a",
                                  value: "Art",
                                )
                              )
    end
  end
end
