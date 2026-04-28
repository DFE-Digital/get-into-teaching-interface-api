# frozen_string_literal: true

require "rails_helper"
require "rails/generators"
require "generators/crm_endpoint/crm_endpoint_generator"

RSpec.describe CrmEndpointGenerator do
  def generator(path)
    described_class.new([path], {}, destination_root: Rails.root.to_s)
  end

  describe "path parsing with a 2-level path" do
    subject(:gen) { generator("lookup_items/countries") }

    it "sets depth to 2"          do expect(gen.depth).to eq(2) end
    it "sets list_type"           do expect(gen.list_type).to eq("lookup_items") end
    it "sets category to nil"     do expect(gen.category).to be_nil end
    it "sets collection"          do expect(gen.collection).to eq("countries") end
    it "sets singular"            do expect(gen.singular).to eq("country") end
  end

  describe "path parsing with a 3-level path" do
    subject(:gen) { generator("pick_list_items/candidate/initial_teacher_training_years") }

    it "sets depth to 3"    do expect(gen.depth).to eq(3) end
    it "sets list_type"     do expect(gen.list_type).to eq("pick_list_items") end
    it "sets category"      do expect(gen.category).to eq("candidate") end
    it "sets collection"    do expect(gen.collection).to eq("initial_teacher_training_years") end
    it "sets singular"      do expect(gen.singular).to eq("initial_teacher_training_year") end
  end

  describe "#class_name_for" do
    subject(:gen) { generator("lookup_items/countries") }

    it "camelizes and appends Resource for a simple segment" do
      expect(gen.class_name_for("look_up_items")).to eq("LookUpItemsResource")
    end

    it "camelizes and appends Resource for a multi-word segment" do
      expect(gen.class_name_for("initial_teacher_training_years")).to eq("InitialTeacherTrainingYearsResource")
    end
  end

  describe "derived name helpers (depth-2)" do
    # Uses lookup_items/countries to verify depth-2 derivation.
    # Note: "lookup_items".camelize => "LookupItems" (no underscore between Look/Up).
    # Existing CRM resources use look_up_items (with underscore) — that's pre-generator legacy.
    subject(:gen) { generator("lookup_items/countries") }

    it { expect(gen.list_type_class).to eq("LookupItemsResource") }
    it { expect(gen.collection_class).to eq("CountriesResource") }
    it { expect(gen.singular_class).to eq("CountryResource") }
    it { expect(gen.list_type_module).to eq("LookupItems") }
    it { expect(gen.category_module).to be_nil }
    it { expect(gen.crm_resource_ns).to eq("CRM::Resources::LookupItems") }
    it { expect(gen.list_type_first_method).to eq("countries") }
    it { expect(gen.list_type_first_method_return).to eq("LookupItems::CountriesResource") }
    it { expect(gen.api_path).to eq("/api/lookup_items/countries") }
    it { expect(gen.fluent_chain).to eq("CRM::Client.new.lookup_items.countries.all") }
    it { expect(gen.controller_class).to eq("API::LookupItems::CountriesController") }
    it { expect(gen.route_helper).to eq("api_lookup_items_countries_path") }
  end

  describe "derived name helpers (depth-3)" do
    subject(:gen) { generator("pick_list_items/candidate/initial_teacher_training_years") }

    it { expect(gen.list_type_class).to eq("PickListItemsResource") }
    it { expect(gen.category_class).to eq("CandidateResource") }
    it { expect(gen.collection_class).to eq("InitialTeacherTrainingYearsResource") }
    it { expect(gen.singular_class).to eq("InitialTeacherTrainingYearResource") }
    it { expect(gen.list_type_module).to eq("PickListItems") }
    it { expect(gen.category_module).to eq("Candidate") }
    it { expect(gen.crm_resource_ns).to eq("CRM::Resources::PickListItems::Candidate") }
    it { expect(gen.list_type_first_method).to eq("candidate") }
    it { expect(gen.list_type_first_method_return).to eq("PickListItems::CandidateResource") }
    it { expect(gen.api_path).to eq("/api/pick_list_items/candidate/initial_teacher_training_years") }
    it { expect(gen.fluent_chain).to eq("CRM::Client.new.pick_list_items.candidate.initial_teacher_training_years.all") }
    it { expect(gen.controller_class).to eq("API::PickListItems::Candidate::InitialTeacherTrainingYearsController") }
    it { expect(gen.route_helper).to eq("api_pick_list_items_candidate_initial_teacher_training_years_path") }
  end

  describe "argument validation" do
    it "raises ArgumentError for a 1-segment path" do
      expect { generator("only_one_segment") }
        .to raise_error(ArgumentError, /path must have 2 or 3 segments/)
    end

    it "raises ArgumentError for a 4-segment path" do
      expect { generator("a/b/c/d") }
        .to raise_error(ArgumentError, /path must have 2 or 3 segments/)
    end
  end
end
