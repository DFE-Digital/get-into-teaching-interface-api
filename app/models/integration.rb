class Integration < ApplicationRecord
  has_many :api_tokens, dependent: :destroy

  validates :name,
          presence: true,
          uniqueness: { case_sensitive: false }
end
