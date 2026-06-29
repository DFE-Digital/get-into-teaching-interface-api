require "rails_helper"

RSpec.describe "API::TeachingEvents", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  let(:teaching_events_resource) do
    instance_double(CRM::Adapters::GetIntoTeaching::Resources::TeachingEventsResource)
  end
  let(:crm_client) { instance_double(CRM::Client, teaching_events: teaching_events_resource) }

  before do
    allow(CRM::Client).to receive(:new).and_return(crm_client)
  end

  describe "GET /api/teaching_events/search" do
    let(:events_data) do
      [
        {
          readable_id: "250930-get-into-teaching-north-event",
          name: "Get into Teaching - North",
          type_id: 222750000,
          status_id: 222750001,
          is_online: false,
          start_at: "2026-07-15T10:00:00Z",
          end_at: "2026-07-15T16:00:00Z",
        },
      ]
    end

    before do
      allow(teaching_events_resource).to receive(:all).and_return(events_data)
    end

    it "returns JSON" do
      get search_api_teaching_events_path, headers:, params: { postcode: "SW1A 1AA", radius: 10 }
      expect(response.content_type).to match(%r{application/json})
    end

    it "returns 200" do
      get search_api_teaching_events_path, headers:, params: { postcode: "SW1A 1AA", radius: 10 }
      expect(response).to have_http_status(:ok)
    end

    it "returns an array of events" do
      get search_api_teaching_events_path, headers:, params: { postcode: "SW1A 1AA", radius: 10 }
      expect(response.parsed_body).to be_an(Array)
      expect(response.parsed_body.first).to include(
        "readable_id" => "250930-get-into-teaching-north-event",
        "name" => "Get into Teaching - North",
      )
    end

    it "camelizes the search params" do
      get search_api_teaching_events_path, headers:, params: { postcode: "SW1A 1AA", radius: 10 }
      expect(teaching_events_resource).to have_received(:all).with(
        hash_including("Postcode" => "SW1A 1AA", "Radius" => "10")
      )
    end

    describe "when no auth token is provided" do
      it "returns 401" do
        get search_api_teaching_events_path
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "when the CRM is unavailable" do
      before do
        allow(teaching_events_resource).to receive(:all)
          .and_raise(CRM::Adapters::GetIntoTeaching::Resource::Error)
      end

      it "returns 503" do
        get search_api_teaching_events_path, headers:, params: { postcode: "SW1A 1AA" }
        expect(response).to have_http_status(:service_unavailable)
      end
    end
  end

  describe "GET /api/teaching_events/:id" do
    let(:event_data) do
      {
        readable_id: "250930-get-into-teaching-north-event",
        name: "Get into Teaching - North",
        type_id: 222750000,
        status_id: 222750001,
        is_online: false,
        start_at: "2026-07-15T10:00:00Z",
        end_at: "2026-07-15T16:00:00Z",
      }
    end

    before do
      allow(teaching_events_resource).to receive(:find).and_return(event_data)
    end

    it "returns JSON" do
      get(api_teaching_event_path("250930-get-into-teaching-north-event"), headers:)
      expect(response.content_type).to match(%r{application/json})
    end

    it "returns 200" do
      get(api_teaching_event_path("250930-get-into-teaching-north-event"), headers:)
      expect(response).to have_http_status(:ok)
    end

    it "returns the event" do
      get(api_teaching_event_path("250930-get-into-teaching-north-event"), headers:)
      expect(response.parsed_body).to include(
        "readable_id" => "250930-get-into-teaching-north-event",
        "name" => "Get into Teaching - North",
      )
    end

    it "passes the id to the resource" do
      get(api_teaching_event_path("250930-get-into-teaching-north-event"), headers:)
      expect(teaching_events_resource).to have_received(:find).with("250930-get-into-teaching-north-event")
    end

    describe "when no auth token is provided" do
      it "returns 401" do
        get api_teaching_event_path("some-id")
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "when the event is not found" do
      before do
        allow(teaching_events_resource).to receive(:find)
          .and_raise(CRM::Adapters::GetIntoTeaching::Resource::NotFoundError)
      end

      it "returns 404" do
        get(api_teaching_event_path("unknown-id"), headers:)
        expect(response).to have_http_status(:not_found)
      end
    end

    describe "when the CRM is unavailable" do
      before do
        allow(teaching_events_resource).to receive(:find)
          .and_raise(CRM::Adapters::GetIntoTeaching::Resource::Error)
      end

      it "returns 503" do
        get(api_teaching_event_path("some-id"), headers:)
        expect(response).to have_http_status(:service_unavailable)
      end
    end
  end

  describe "POST /api/teaching_events" do
    let(:valid_attributes) do
      {
        type_id: 222750000,
        status_id: 222750001,
        readable_id: "250930-get-into-teaching-north-event",
        name: "Get into Teaching - North",
        start_at: "2026-07-15T10:00:00Z",
        end_at: "2026-07-15T16:00:00Z",
      }
    end

    let(:created_event) do
      {
        readable_id: "250930-get-into-teaching-north-event",
        name: "Get into Teaching - North",
        type_id: 222750000,
        status_id: 222750001,
        is_online: false,
        start_at: "2026-07-15T10:00:00Z",
        end_at: "2026-07-15T16:00:00Z",
      }
    end

    before do
      allow(teaching_events_resource).to receive(:create).and_return(created_event)
    end

    it "returns JSON" do
      post api_teaching_events_path, params: valid_attributes, headers:, as: :json
      expect(response.content_type).to match(%r{application/json})
    end

    it "returns 201" do
      post api_teaching_events_path, params: valid_attributes, headers:, as: :json
      expect(response).to have_http_status(:created)
    end

    it "returns the created event" do
      post api_teaching_events_path, params: valid_attributes, headers:, as: :json
      expect(response.parsed_body).to include(
        "readable_id" => "250930-get-into-teaching-north-event",
        "name" => "Get into Teaching - North",
      )
    end

    describe "when params are invalid" do
      let(:invalid_attributes) { { name: "Incomplete Event" } }

      it "returns 400" do
        post api_teaching_events_path, params: invalid_attributes, headers:, as: :json
        expect(response).to have_http_status(:bad_request)
      end

      it "returns validation errors" do
        post api_teaching_events_path, params: invalid_attributes, headers:, as: :json
        expect(response.parsed_body).to have_key("errors")
        expect(response.parsed_body["errors"]).to be_an(Array)
      end

      it "does not call the CRM" do
        post api_teaching_events_path, params: invalid_attributes, headers:, as: :json
        expect(teaching_events_resource).not_to have_received(:create)
      end
    end

    describe "when the CRM returns a bad request" do
      let(:errors) do
        [
          CRM::Adapters::GetIntoTeaching::Resource::ErrorObjects.new(
            attribute: "name",
            message: "can't be blank",
          ),
        ]
      end

      before do
        allow(teaching_events_resource).to receive(:create)
          .and_raise(CRM::Adapters::GetIntoTeaching::Resource::BadRequestError.new(errors))
      end

      it "returns 400" do
        post api_teaching_events_path, params: valid_attributes, headers:, as: :json
        expect(response).to have_http_status(:bad_request)
      end

      it "returns structured error objects" do
        post api_teaching_events_path, params: valid_attributes, headers:, as: :json
        expect(response.parsed_body["errors"].first).to include(
          "error" => "BadRequest",
          "message" => "can't be blank",
          "attribute" => "name",
        )
      end
    end

    describe "when no auth token is provided" do
      it "returns 401" do
        post api_teaching_events_path, params: valid_attributes, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "when the CRM is unavailable" do
      before do
        allow(teaching_events_resource).to receive(:create)
          .and_raise(CRM::Adapters::GetIntoTeaching::Resource::Error)
      end

      it "returns 503" do
        post api_teaching_events_path, params: valid_attributes, headers:, as: :json
        expect(response).to have_http_status(:service_unavailable)
      end
    end
  end
end
