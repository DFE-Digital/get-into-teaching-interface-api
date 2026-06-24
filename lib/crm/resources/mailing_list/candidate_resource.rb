module CRM
  module Resources
    module MailingList
      CandidateResource = Data.define(
        :candidate_id,
        :qualification_id,
        :preferred_teaching_subject_id,
        :accepted_policy_id,
        :consideration_journey_stage_id,
        :channel_id,
        :creation_channel_source_id,
        :creation_channel_service_id,
        :creation_channel_activity_id,
        :email,
        :first_name,
        :last_name,
        :address_postcode,
        :welcome_guide_variant,
        :already_subscribed_to_events,
        :already_subscribed_to_mailing_list,
        :already_subscribed_to_teacher_training_adviser,
        :default_contact_creation_channel,
        :default_creation_channel_source_id,
        :default_creation_channel_service_id,
        :default_creation_channel_activity_id,
        :situation,
        :citizenship,
        :visa_status,
        :location,
        :graduation_year,
        :inferred_graduation_date,
        :degree_status_id,
      )
    end
  end
end
