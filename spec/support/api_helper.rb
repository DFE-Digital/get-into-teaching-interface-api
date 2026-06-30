module APIHelper
  def self.included(base)
    base.before do
      allow(CRM::Client).to receive(:new).and_return(
        CRM::Client.new(adapter: CRM::Adapters::Demo::Client.new)
      )
    end
  end

  def headers
    @headers ||= { "Authorization" => "Bearer #{api_token}" }
  end

  def api_token
    @api_token ||= APIToken.create_with_random_token!(integration: create(:integration), role: :admin)
  end
end
