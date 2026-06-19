module GetIntoTeaching
  class Callback
    include ActiveModel::Model
    include ActiveModel::Attributes
    attr_reader :client

    ATTRIBUTES = [
      { name: :email },
      { name: :first_name },
      { name: :last_name },
      { name: :address_telephone },
      { name: :phone_call_scheduled_at },
      { name: :talking_points },
      { name: :accepted_policy_id },
      { name: :candidate_id },
    ].freeze

    ATTRIBUTES.each do |attribute_hash|
      attribute attribute_hash[:name], attribute_hash.fetch(:type, :string)
    end

    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :address_telephone, presence: true
    validates :address_telephone, presence: true
    validates :phone_call_scheduled_at, presence: true
    validates :talking_points, presence: true
    validates :accepted_policy_id, presence: true

    def initialize(client:, request_params:)
      @client = client
      super(request_params)
    end

    def create
      valid? && client.get_into_teaching.create_callback(body)
    end

    private

    def body
      attributes.compact.transform_keys { |key| key.camelize(:lower) }
    end
  end
end
