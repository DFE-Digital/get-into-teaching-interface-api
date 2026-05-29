require 'rails_helper'

RSpec.describe Integration, type: :model do
  subject { build(:integration) }

  describe "associations" do
    it { is_expected.to have_many(:api_tokens) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end
end
