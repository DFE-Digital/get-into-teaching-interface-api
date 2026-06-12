module TeacherTrainingAdviser
  class ExchangeAccessToken
    include ActiveModel::Model
    include ActiveModel::Attributes

    attr_reader :client

    attribute :access_token, :string
    attribute :email, :string
    attribute :first_name, :string
    attribute :last_name, :string
    attribute :date_of_birth, :date

    validates :access_token, presence: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

    def initialize(client:, request_params:)
      @client = client
      super(request_params)
    end

    def call
      valid? && client.teacher_training_adviser.exchange_access_token(access_token, body)
    end

    private

    def body
      attributes.except("access_token").compact.transform_keys { |key| key.camelize(:lower) }
    end
  end
end
