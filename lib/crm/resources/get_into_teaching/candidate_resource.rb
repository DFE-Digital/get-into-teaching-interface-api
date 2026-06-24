module CRM
  module Resources
    module GetIntoTeaching
      CandidateResource = Data.define(
        :candidate_id,
        :accepted_policy_id,
        :email,
        :first_name,
        :last_name,
        :address_telephone,
        :phone_call_scheduled_at,
        :talking_points,
        :creation_channel_source_id,
        :creation_channel_service_id,
        :creation_channel_activity_id,
        :default_contact_creation_channel,
        :default_creation_channel_source_id,
        :default_creation_channel_service_id,
        :default_creation_channel_activity_id,
      )
    end
  end
end
