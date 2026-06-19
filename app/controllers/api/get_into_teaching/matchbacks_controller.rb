class API::GetIntoTeaching::MatchbacksController < API::ApplicationController
  def create
    matchback = GetIntoTeaching::Matchback.new(
      client:,
      request_params:
    )

    if response = matchback.create
      render status: 200, json: response.body
    else
      messages = matchback.errors.map do |error|
        "#{error.attribute} #{error.message}"
      end
      render_errors(messages, :bad_request)
    end
  end

  private

  def request_params
    params.permit(
      GetIntoTeaching::Matchback::ATTRIBUTES.map { |attr| attr[:name] }
    )
  end

  def client
    @client ||= CRM::Client.new
  end
end
