module SchoolsExperience
  class CandidateSchoolExperience
    include ActiveModel::Model
    include ActiveModel::Attributes
    attr_reader :client

    ATTRIBUTES = [
      { name: :id },
      { name: :school_urn },
      { name: :duration_of_placement_in_days, type: :integer },
      { name: :date_of_school_experience },
      { name: :teaching_subject_id },
      { name: :notes },
      { name: :school_name },
      { name: :status, type: :integer },
    ].freeze

    ATTRIBUTES.each do |attribute_hash|
      attribute attribute_hash[:name], attribute_hash.fetch(:type, :string)
    end

    validates :id, presence: true
    validates :school_urn, presence: true

    def initialize(client:, request_params:)
      @client = client
      super(request_params)
    end

    def create
      valid? && client.schools_experience.create_school_experience(id, body)
    end

    private

    def body
      attributes.except("id").compact.transform_keys { |key| key.camelize(:lower) }
    end
  end
end
