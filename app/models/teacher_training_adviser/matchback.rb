module TeacherTrainingAdviser
  class Matchback
    include ActiveModel::Model
    attr_reader :client, :request_params
    ATTRIBUTES = [
      :email, :first_name, :last_name, :date_of_birth, :reference
    ]
    attr_accessor *ATTRIBUTES

    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

    def initialize(client:, request_params:)
      @client = client
      ATTRIBUTES.each do |attr|
        public_send("#{attr}=", request_params[attr])
      end
    end

    def create
      valid? && client.teacher_training_adviser.matchback(body)
    end

    private

    def body
      ATTRIBUTES.to_h { |attr| [ attr.to_s.camelize(:lower), public_send(attr) ] }
    end
  end
end
