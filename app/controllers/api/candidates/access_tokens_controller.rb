class API::Candidates::AccessTokensController < API::ApplicationController
  def create
    access_token = Candidate::AccessToken.new(
      client:,
      request_params:
    )

    if access_token.create
      render status: :no_content
    else
      messages = access_token.errors.map do |error|
        "#{error.attribute} #{error.message}"
      end
      render_errors(messages, :bad_request)
    end
  end

private

  def request_params
    params.permit(Candidate::AccessToken::ATTRIBUTES.map { |attr| attr[:name] })
  end

private

  def client
    @client ||= CRM::Client.new(
      adapter: CRM::Adapters::GetIntoTeaching::Client.new,
    )
  end
end
