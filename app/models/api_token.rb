class APIToken < ApplicationRecord
  belongs_to :integration

  validates :hashed_token, presence: true

  scope :used_in_last_3_months, -> { where("last_used_at >= ?", 3.months.ago) }

  def self.create_with_random_token!(integration:, **attributes)
    unhashed_token, hashed_token = Devise.token_generator.generate(APIToken, :hashed_token)
    create!(attributes.merge({ hashed_token:, integration: }))
    unhashed_token
  end

  def self.find_by_unhashed_token(unhashed_token)
    hashed_token = Devise.token_generator.digest(APIToken, :hashed_token, unhashed_token)
    find_by(hashed_token:)
  end

  # -r_t6Yy7Rpzf37z4ZSFi
end
