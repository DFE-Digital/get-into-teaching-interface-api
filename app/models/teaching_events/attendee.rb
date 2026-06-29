module TeachingEvents
  class Attendee
    include ActiveModel::Model
    include ActiveModel::Attributes
    attr_reader :client

    attribute :event_id, type: :string
    attribute :email, type: :string
    attribute :first_name, type: :string
    attribute :last_name, type: :string
    attribute :accepted_policy_id, type: :string
    attribute :candidate_id, type: :string
    attribute :qualification_id, type: :string
    attribute :channel_id, type: :integer
    attribute :creation_channel_source_id, type: :integer
    attribute :creation_channel_service_id, type: :integer
    attribute :creation_channel_activity_id, type: :integer
    attribute :preferred_teaching_subject_id, type: :string
    attribute :consideration_journey_stage_id, type: :integer
    attribute :degree_status_id, type: :integer
    attribute :address_postcode, type: :string
    attribute :address_telephone, type: :string
    attribute :is_verified, type: :boolean
    attribute :is_walk_in, type: :boolean
    attribute :subscribe_to_mailing_list, type: :boolean
    attribute :already_subscribed_to_events, type: :boolean
    attribute :already_subscribed_to_mailing_list, type: :boolean
    attribute :already_subscribed_to_teacher_training_adviser, type: :boolean
    attribute :accessibility_needs_for_event, type: :string

    validates :event_id, presence: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :accepted_policy_id, presence: true

    def initialize(client:, request_params:)
      @client = client
      super(request_params)
    end

    def create
      valid? && client.teaching_events.create_attendee(body)
    end

    private

    def body
      attributes.compact.deep_transform_keys { |key| key.camelize(:lower) }
    end
  end
end
