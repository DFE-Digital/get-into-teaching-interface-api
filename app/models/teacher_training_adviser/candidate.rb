module TeacherTrainingAdviser
  class Candidate
    include ActiveModel::Model
    attr_reader :client, :request_params
    ATTRIBUTES = [
      :email, :first_name, :last_name, :date_of_birth, :address_telephone,
      :address_postcode, :country_id, :degree_subject, :uk_degree_grade_id,
      :degree_status_id, :degree_type_id, :has_gcse_maths_and_english_id,
      :planning_to_retake_gcse_maths_and_english_id, :has_gcse_science_id,
      :planning_to_retake_gcse_science_id, :preferred_teaching_subject_id,
      :preferred_education_phase_id, :initial_teacher_training_year_id, :accepted_policy_id,
      :type_id, :channel_id, :candidate_id, :adviser_status_id, :qualification_id,
      :creation_channel_source_id, :creation_channel_service_id, :creation_channel_activity_id
    ]
    attr_accessor *ATTRIBUTES

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :date_of_birth, presence: true
    validates :accepted_policy_id, presence: true
    validates :country_id, presence: true
    validates :type_id, presence: true

    def initialize(client:, request_params:)
      @client = client
      ATTRIBUTES.each do |attr|
        public_send("#{attr}=", request_params[attr])
      end
    end

    def create
      valid? && client.teacher_training_adviser.candidates(body)
    end

    private

    def body
      ATTRIBUTES.to_h { |attr| [ attr.to_s.camelize(:lower), public_send(attr) ] }
    end
  end
end
