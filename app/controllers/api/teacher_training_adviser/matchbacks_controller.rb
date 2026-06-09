class API::TeacherTrainingAdviser::MatchbacksController < API::ApplicationController

  def create
    client = CRM::Client.new(
      adapter: CRM::Adapters::GetIntoTeaching::Client.new,
    )

    matchback = TeacherTrainingAdviser::Matchback.new(
      client:,
      request_params:
    )

    if matchback.create
      render status: 200, json: { response: "OK" }
    else
      errors = matchback.errors.map { |error| "#{error.attribute} #{error.message}" }
      render status: 400, json: { errors: }
    end
  end

  private

  def request_params
    params.expect(
      candidate: TeacherTrainingAdviser::Matchback::ATTRIBUTES
    )
  end
end
