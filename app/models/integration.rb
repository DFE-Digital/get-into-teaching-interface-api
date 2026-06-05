class Integration < ApplicationRecord
  has_many :api_tokens

  validates :name,
          presence: true,
          uniqueness: { case_sensitive: false }

  normalizes :name, with: ->(name) { name.strip }
end
