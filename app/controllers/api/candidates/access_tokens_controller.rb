class API::Candidates::AccessTokensController < API::ApplicationController
  def create
    access_token = Candidate::AccessToken.new(
      client:,
      request_params:
    )

    if access_token.create
      render status: 200, json: { response: "OK" }
    else
      errors = access_token.errors.map { |error| "#{error.attribute} #{error.message}" }
      render status: 400, json: { errors: }
    end
  end

private

  def request_params
    params.permit(Candidate::AccessToken::ATTRIBUTES.map { |attr| attr[:name] })
  end

private

  def client
    @client ||= CRM::Client.new
  end
end
