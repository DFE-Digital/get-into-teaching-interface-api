module Candidate
  class AccessToken
    include ActiveModel::Model
    include ActiveModel::Attributes
    attr_reader :client

    ATTRIBUTES = [
      { name: :email },
      { name: :first_name },
      { name: :last_name },
      { name: :date_of_birth, type: :date },
    ].freeze

    ATTRIBUTES.each do |attribute_hash|
      attribute attribute_hash[:name], attribute_hash.fetch(:type, :string)
    end

    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

    def initialize(client:, request_params:)
      @client = client
      super(request_params)
    end

    def create
      valid? && client.candidates.create_access_token(body)
    end

    private

    def body
      attributes.compact.transform_keys { |key| key.camelize(:lower) }
    end
  end
end
