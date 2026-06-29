class API::TeachingEvents::AttendeesController < API::ApplicationController
  def create
    attendee = TeachingEvents::Attendee.new(
      client:,
      request_params:
    )

    if data = attendee.create
      render status: 204
    else
      messages = attendee.errors.map do |error|
        "#{error.attribute} #{error.message}"
      end
      render_errors(messages, :bad_request)
    end
  end

private

  def request_params
    params.permit(
      :event_id,
      :email,
      :first_name,
      :last_name,
      :accepted_policy_id,
      :candidate_id,
      :qualification_id,
      :channel_id,
      :creation_channel_source_id,
      :creation_channel_service_id,
      :creation_channel_activity_id,
      :preferred_teaching_subject_id,
      :consideration_journey_stage_id,
      :degree_status_id,
      :address_postcode,
      :address_telephone,
      :is_verified,
      :is_walk_in,
      :subscribe_to_mailing_list,
      :already_subscribed_to_events,
      :already_subscribed_to_mailing_list,
      :already_subscribed_to_teacher_training_adviser,
      :accessibility_needs_for_event,
    )
  end

  def client
    @client ||= CRM::Client.new(
      adapter: CRM::Adapters::GetIntoTeaching::Client.new,
    )
  end
end
