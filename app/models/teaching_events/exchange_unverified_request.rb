module TeachingEvents
  class ExchangeUnverifiedRequest
    include ActiveModel::Model
    include ActiveModel::Attributes
    attr_reader :client

    attribute :email, type: :string
    attribute :first_name, type: :string
    attribute :last_name, type: :string
    attribute :date_of_birth
    attribute :reference, type: :string

    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

    def initialize(client:, request_params:)
      @client = client
      super(request_params)
    end

    def call
      valid? && client.teaching_events.exchange_unverified_request(body)
    end

    private

    def body
      attributes.compact.deep_transform_keys { |key| key.camelize(:lower) }
    end
  end
end
