module SchoolsExperience
  class Candidate
    include ActiveModel::Model
    include ActiveModel::Attributes
    attr_reader :client

    ATTRIBUTES = [
      { name: :email },
      { name: :first_name },
      { name: :last_name },
      { name: :preferred_teaching_subject_id },
      { name: :secondary_preferred_teaching_subject_id },
      { name: :address_line1 },
      { name: :address_line2 },
      { name: :address_line3 },
      { name: :address_city },
      { name: :address_state_or_province },
      { name: :address_postcode },
      { name: :telephone },
      { name: :has_dbs_certificate, type: :boolean },
      { name: :dbs_certificate_issued_at },
      { name: :qualification_id },
      { name: :degree_status_id },
      { name: :degree_type_id },
      { name: :degree_subject },
      { name: :uk_degree_grade_id },
      { name: :candidate_id },
      { name: :creation_channel_source_id },
      { name: :creation_channel_service_id },
      { name: :creation_channel_activity_id },
      { name: :accepted_policy_id },
    ].freeze

    ATTRIBUTES.each do |attribute_hash|
      attribute attribute_hash[:name], attribute_hash.fetch(:type, :string)
    end

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :preferred_teaching_subject_id, presence: true
    validates :accepted_policy_id, presence: true
    validates :address_line1, presence: true
    validates :address_city, presence: true
    validates :address_state_or_province, presence: true
    validates :address_postcode, presence: true
    validates :telephone, presence: true
    validates :has_dbs_certificate, presence: true

    def initialize(client:, request_params:)
      @client = client
      super(request_params)
    end

    def create
      valid? && client.schools_experience.create_candidate(body)
    end

    private

    def body
      attributes.compact.transform_keys { |key| key.camelize(:lower) }
    end
  end
end
