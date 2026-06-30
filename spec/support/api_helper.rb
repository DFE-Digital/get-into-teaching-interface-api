module APIHelper
  class TestCRMNamespace
    def all
      [ { "id" => "1", "value" => "test" } ]
    end

    def find(*)
      { "id" => "1", "value" => "test", "text" => "test", "created_at" => "2026-01-01T00:00:00Z" }
    end

    def method_missing(name, *args)
      self
    end

    def respond_to_missing?(...)
      true
    end
  end

  def self.included(base)
    base.before do
      client = instance_double(CRM::Client)
      namespace = APIHelper::TestCRMNamespace.new
      allow(client).to receive(:pick_list_items).and_return(namespace)
      allow(client).to receive(:callback_booking_quotas).and_return(namespace)
      allow(client).to receive(:privacy_policies).and_return(namespace)
      allow(client).to receive(:teaching_event_buildings).and_return(namespace)
      allow(CRM::Client).to receive(:new).and_return(client)
    end
  end

  def headers
    @headers ||= { "Authorization" => "Bearer #{api_token}" }
  end

  def api_token
    @api_token ||= APIToken.create_with_random_token!(integration: create(:integration), role: :admin)
  end
end
