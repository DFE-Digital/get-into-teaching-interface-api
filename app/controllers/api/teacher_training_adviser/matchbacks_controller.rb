class API::TeacherTrainingAdviser::MatchbacksController < API::ApplicationController
  def create
    matchback = TeacherTrainingAdviser::Matchback.new(
      client:,
      request_params:
    )

    if response = matchback.create
      render status: 200, json: response.body
    else
      errors = matchback.errors.map do |error|
        {
          error: "BadRequest",
          message: "#{error.attribute} #{error.message}",
        }
      end
      render status: 400, json: { errors: }
    end
  end

  private

  def request_params
    params.permit(
      TeacherTrainingAdviser::Matchback::ATTRIBUTES.map { |attr| attr[:name] }
    )
  end

  def client
    @client ||= CRM::Client.new
  end
end
