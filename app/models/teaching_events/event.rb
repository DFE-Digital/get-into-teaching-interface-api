module TeachingEvents
  class Event
    include ActiveModel::Model
    include ActiveModel::Attributes
    attr_reader :client

    attribute :type_id, type: :integer
    attribute :status_id, type: :integer
    attribute :readable_id, type: :string
    attribute :name, type: :string
    attribute :start_at
    attribute :end_at
    attribute :is_online, type: :boolean
    attribute :building
    attribute :web_feed_id, type: :string
    attribute :summary, type: :string
    attribute :description, type: :string
    attribute :video_url, type: :string
    attribute :provider_website_url, type: :string
    attribute :provider_target_audience, type: :string
    attribute :provider_organiser, type: :string
    attribute :provider_contact_email, type: :string
    attribute :providers_list, type: :string
    attribute :region_id, type: :integer
    attribute :message, type: :string
    attribute :scribble_id, type: :string
    attribute :accessibility_options

    validates :type_id, presence: true
    validates :status_id, presence: true
    validates :readable_id, presence: true
    validates :name, presence: true
    validates :start_at, presence: true
    validates :end_at, presence: true

    def initialize(client:, request_params:)
      @client = client
      super(request_params)
    end

    def create
      valid? && client.teaching_events.create(body)
    end

    private

    def body
      attributes.compact.deep_transform_keys { |key| key.camelize(:lower) }
    end
  end
end
