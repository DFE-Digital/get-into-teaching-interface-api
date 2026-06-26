class API::TeachingEventsController < API::ApplicationController
  def search
    render json: client.teaching_events.all(search_params)
  end

  def show
    render json: client.teaching_events.find(params.expect(:id))
  end

  def create
    event = TeachingEvents::Event.new(
      client:,
      request_params:
    )

    if data = event.create
      render status: 201, json: data
    else
      messages = event.errors.map do |error|
        "#{error.attribute} #{error.message}"
      end
      render_errors(messages, :bad_request)
    end
  end

private

  def search_params
    params.permit(
      :postcode,
      :radius,
      :online,
      :start_after,
      :start_before,
      :quantity,
      :type_ids,
      :status_ids,
      :accessibility_options
    ).transform_keys(&:camelize)
  end

  def request_params
    params.permit(
      :type_id,
      :status_id,
      :readable_id,
      :name,
      :start_at,
      :end_at,
      :is_online,
      :web_feed_id,
      :summary,
      :description,
      :video_url,
      :provider_website_url,
      :provider_target_audience,
      :provider_organiser,
      :provider_contact_email,
      :providers_list,
      :region_id,
      :message,
      :scribble_id,
      building: {},
      accessibility_options: []
    )
  end

  def client
    @client ||= CRM::Client.new(
      adapter: CRM::Adapters::GetIntoTeaching::Client.new,
    )
  end
end
