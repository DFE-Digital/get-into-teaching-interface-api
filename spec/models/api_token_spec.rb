require 'rails_helper'

RSpec.describe APIToken, type: :model do
  subject { build(:api_token) }

  describe "associations" do
    it { is_expected.to belong_to(:integration) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:hashed_token) }
  end

  describe ".create_with_random_token!" do
    it "creates an APIToken with a hashed token" do
      integration = create(:integration)

      unhashed = APIToken.create_with_random_token!(integration:, role: :admin)

      expect(APIToken.find_by_unhashed_token(unhashed)).to be_present
    end

    it "returns the unhashed token" do
      unhashed = APIToken.create_with_random_token!(integration: create(:integration), role: :admin)

      expect(unhashed).to be_a(String)
      expect(unhashed).not_to be_empty
    end

    it "stores the hashed version in the database" do
      integration = create(:integration)

      unhashed = APIToken.create_with_random_token!(integration:, role: :admin)
      token_record = APIToken.find_by_unhashed_token(unhashed)

      expect(token_record.hashed_token).not_to eq(unhashed)
    end

    it "persists the record" do
      expect do
        APIToken.create_with_random_token!(integration: create(:integration), role: :admin)
      end.to change(described_class, :count).by(1)
    end
  end

  describe ".find_by_unhashed_token" do
    it "returns the token record for a valid unhashed token" do
      unhashed = APIToken.create_with_random_token!(integration: create(:integration), role: :admin)

      found = APIToken.find_by_unhashed_token(unhashed)

      expect(found).to be_present
      expect(found.hashed_token).to be_present
    end

    it "returns nil for an unknown token" do
      expect(APIToken.find_by_unhashed_token("invalid-token")).to be_nil
    end
  end

  describe ".used_in_last_3_months" do
    it "includes tokens used recently" do
      recent = create(:api_token, last_used_at: 1.day.ago)

      expect(described_class.used_in_last_3_months).to include(recent)
    end

    it "excludes tokens not used in the last 3 months" do
      stale = create(:api_token, last_used_at: 4.months.ago)

      expect(described_class.used_in_last_3_months).not_to include(stale)
    end
  end

  describe "#crm_key" do
    let(:token) { build(:api_token, role:) }

    before do
      allow(ENV).to receive(:fetch).with("ADMIN_CRM_KEY").and_return("admin-secret")
      allow(ENV).to receive(:fetch).with("GIT_CRM_KEY").and_return("git-secret")
      allow(ENV).to receive(:fetch).with("SCHOOLS_EXPERIENCE_CRM_KEY").and_return("schools-secret")
      allow(ENV).to receive(:fetch).with("APPLY_CRM_KEY").and_return("apply-secret")
    end

    context "when role is admin" do
      let(:role) { :admin }

      it "returns the ADMIN_CRM_KEY" do
        expect(token.crm_key).to eq("admin-secret")
      end
    end

    context "when role is get_into_teaching" do
      let(:role) { :get_into_teaching }

      it "returns the GIT_CRM_KEY" do
        expect(token.crm_key).to eq("git-secret")
      end
    end

    context "when role is schools_experience" do
      let(:role) { :schools_experience }

      it "returns the SCHOOLS_EXPERIENCE_CRM_KEY" do
        expect(token.crm_key).to eq("schools-secret")
      end
    end

    context "when role is apply" do
      let(:role) { :apply }

      it "returns the APPLY_CRM_KEY" do
        expect(token.crm_key).to eq("apply-secret")
      end
    end
  end
end
