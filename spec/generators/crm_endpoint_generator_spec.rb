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
