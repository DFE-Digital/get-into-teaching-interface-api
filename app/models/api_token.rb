class APIToken < ApplicationRecord
  belongs_to :integration

  audited associated_with: :integration

  validates :hashed_token, presence: true

  scope :used_in_last_3_months, -> { where("last_used_at >= ?", 3.months.ago) }

  def self.create_with_random_token!(integration:, **attributes)
    unhashed_token, hashed_token = TokenGenerator.generate(APIToken, :hashed_token)
    create!(attributes.merge({ hashed_token:, integration: }))
    unhashed_token
  end

  def self.find_by_unhashed_token(unhashed_token)
    hashed_token = TokenGenerator.digest(APIToken, :hashed_token, unhashed_token)
    find_by(hashed_token:)
  end
end
