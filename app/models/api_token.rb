class APIToken < ApplicationRecord
  belongs_to :integration

  audited associated_with: :integration

  validates :hashed_token, presence: true

  scope :used_in_last_3_months, -> { where("last_used_at >= ?", 3.months.ago) }

  enum :role, {
    admin: "admin",
    get_into_teaching: "get_into_teaching",
    get_an_adviser: "get_an_adviser",
    crm: "crm",
    schools_experience: "schools_experience",
    apply: "apply",
  }, validate: true

  # Z7LsfjEtKxhLkRBN_3tH

  def self.create_with_random_token!(integration:, **attributes)
    unhashed_token, hashed_token = TokenGenerator.generate(APIToken, :hashed_token)
    create!(attributes.merge({ hashed_token:, integration: }))
    unhashed_token
  end

  def self.find_by_unhashed_token(unhashed_token)
    hashed_token = TokenGenerator.digest(APIToken, :hashed_token, unhashed_token)
    find_by(hashed_token:)
  end

  def crm_key
    case role
    when "admin"
      ENV.fetch("ADMIN_CRM_KEY")
    when "get_into_teaching"
      ENV.fetch("GIT_CRM_KEY")
    when "get_an_adviser"
    when "crm"
    when "schools_experience"
      ENV.fetch("SCHOOLS_EXPERIENCE_CRM_KEY")
    when "apply"
    end
  end
end
