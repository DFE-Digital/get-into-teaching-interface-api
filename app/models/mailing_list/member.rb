module MailingList
  class Member
    include ActiveModel::Model
    include ActiveModel::Attributes
    attr_reader :client

    ATTRIBUTES = [
      { name: :email },
      { name: :first_name },
      { name: :last_name },
      { name: :accepted_policy_id },
      { name: :qualification_id },
      { name: :consideration_journey_stage_id, type: :integer },
      { name: :preferred_teaching_subject_id },
      { name: :address_postcode },
      { name: :graduation_year, type: :integer },
      { name: :degree_status_id, type: :integer },
      { name: :welcome_guide_variant },
      { name: :candidate_id },
      { name: :situation, type: :integer },
      { name: :citizenship, type: :integer },
      { name: :visa_status, type: :integer },
      { name: :location, type: :integer },
      { name: :channel_id, type: :integer },
      { name: :creation_channel_source_id, type: :integer },
      { name: :creation_channel_service_id, type: :integer },
      { name: :creation_channel_activity_id, type: :integer },
      { name: :already_subscribed_to_events, type: :boolean },
      { name: :already_subscribed_to_mailing_list, type: :boolean },
      { name: :already_subscribed_to_teacher_training_adviser, type: :boolean },
      { name: :inferred_graduation_date },
    ].freeze


    ATTRIBUTES.each do |attribute_hash|
      attribute attribute_hash[:name], attribute_hash.fetch(:type, :string)
    end

    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :accepted_policy_id, presence: true
    validates :consideration_journey_stage_id, presence: true
    validates :preferred_teaching_subject_id, presence: true

    def initialize(client:, request_params:)
      @client = client
      super(request_params)
    end

    def create
      valid? && client.mailing_list.create_member(body)
    end

    private

    def body
      attributes.compact.transform_keys { |key| key.camelize(:lower) }
    end
  end
end
