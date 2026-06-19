module TeacherTrainingAdviser
  class Candidate
    include ActiveModel::Model
    include ActiveModel::Attributes
    attr_reader :client

    ATTRIBUTES = [
      { name: :email },
      { name: :first_name },
      { name: :last_name },
      { name: :date_of_birth, type: :date },
      { name: :address_telephone },
      { name: :address_postcode },
      { name: :country_id },
      { name: :degree_subject },
      { name: :uk_degree_grade_id },
      { name: :degree_status_id },
      { name: :degree_type_id },
      { name: :has_gcse_maths_and_english_id },
      { name: :planning_to_retake_gcse_maths_and_english_id },
      { name: :has_gcse_science_id },
      { name: :planning_to_retake_gcse_science_id },
      { name: :preferred_teaching_subject_id },
      { name: :preferred_education_phase_id },
      { name: :initial_teacher_training_year_id },
      { name: :accepted_policy_id },
      { name: :type_id },
      { name: :channel_id },
      { name: :candidate_id },
      { name: :adviser_status_id },
      { name: :qualification_id },
      { name: :creation_channel_source_id },
      { name: :creation_channel_service_id },
      { name: :creation_channel_activity_id },
      { name: :subject_taught_id },
      { name: :past_teaching_position_id },
      { name: :stage_taught_id },
      { name: :degree_country },
      { name: :phone_call_scheduled_at },
      { name: :situation },
      { name: :citizenship },
      { name: :visa_status },
      { name: :location },
      { name: :graduation_year },
    ].freeze

    ATTRIBUTES.each do |attribute_hash|
      attribute attribute_hash[:name], attribute_hash.fetch(:type, :string)
    end

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :date_of_birth, presence: true
    validates :accepted_policy_id, presence: true
    validates :country_id, presence: true
    validates :type_id, presence: true

    def initialize(client:, request_params:)
      @client = client
      super(request_params)
    end

    def create
      valid? && client.teacher_training_adviser.create_candidate(body)
    end

    private

    def body
      attributes.compact.transform_keys { |key| key.camelize(:lower) }
    end
  end
end
