require "rails_helper"

RSpec.describe TokenGenerator do
  let(:model) { class_double(APIToken, name: "APIToken") }

  describe ".friendly_token" do
    it "defaults to 20 characters" do
      expect(described_class.friendly_token.length).to eq(20)
    end

    it "accepts a custom length" do
      expect(described_class.friendly_token(32).length).to eq(32)
    end

    it "excludes ambiguous characters (l, I, O, 0)" do
      token = described_class.friendly_token
      expect(token).not_to match(/[lIO0]/)
    end
  end

  describe ".digest" do
    it "returns a SHA256 hexdigest" do
      result = described_class.digest(model, :hashed_token, "raw-token")
      expect(result).to match(/\A[a-f0-9]{64}\z/)
    end

    it "is deterministic" do
      a = described_class.digest(model, :hashed_token, "raw-token")
      b = described_class.digest(model, :hashed_token, "raw-token")
      expect(a).to eq(b)
    end
  end

  describe ".generate" do
    it "returns an array of [raw, enc]" do
      result = described_class.generate(APIToken, :hashed_token)
      expect(result).to be_an(Array)
      expect(result.size).to eq(2)
    end

    it "returns a raw token and its matching digest" do
      raw, enc = described_class.generate(APIToken, :hashed_token)
      expect(described_class.digest(APIToken, :hashed_token, raw)).to eq(enc)
    end

    it "retries when a collision is detected" do
      call_count = 0

      allow(APIToken).to receive(:where) do
        call_count += 1
        instance_double(ActiveRecord::Relation, exists?: call_count == 1)
      end

      raw, enc = described_class.generate(APIToken, :hashed_token)

      expect(raw).to be_a(String)
      expect(enc).to be_a(String)
      expect(call_count).to be >= 2
    end
  end

  describe ".key_for" do
    it "returns string" do
      expect(described_class.key_for(:hashed_token)).to be_a(String)
    end
  end
end
