module APIHelper
  def headers
    @headers ||= { "Authorization" => "Bearer #{api_token}" }
  end

  def api_token
    @api_token ||= APIToken.create_with_random_token!(integration: create(:integration))
  end
end
