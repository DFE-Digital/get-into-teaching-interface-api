/api/get_into_teaching/callbacks 
- phone_call_scheduled_at was in the past. There was no error just returned 400.
- I can post multiple requests to this endpoint but when I hit the get endpoint to get the callbacks, only returns 1. Should it return the latest one? It doesn't do that now.

The POST /api/get_into_teaching/callbacks/matchback and GET /api/get_into_teaching/callbacks are doing the same thing. Is this intentional?

/api/lookup_items/countries - has been removed. Should I use degree_countries endpoint? 

/api/mailing_list/members -- graduation year and degreeStatusID. Some combinations don't work anymore. It should return better error messages

/api/operations/health_check - need to update this

## POST /api/schools_experience/candidates 
- returns 500 if candidateID is not GUID, this should return better error messages, my request has a dodgy candidateID, I should be told that the format is wrong. Not return 500. Same for other GUID field, like qualification-id. Most params in the example request are wrong for this one. 
- It seems like accepted_policy_id is not returned anymore. The old one was returning it but it was nil?


## POST /api/schools_experience/candidates/{id}/school_experience
The error message of this is not helpful when we can't add a school experience because the teaching_subject_id is not found. The error message says that the candidate is not found.

## POST /api/teacher_training_adviser/candidates
Body is outdated. This is a correct body 
{
  "email": "johndoe@example.com",
  "first_name": "John",
  "last_name": "Doe",
  "date_of_birth": "2000-01-01",
  "address_telephone": "07735 111111",
  "address_postcode": "BN1 1AA",
  "teacher_id": "1234567",
  "country_id": "38ce2d0f-0b1f-ee11-9967-6045bd8c5762",
  "degree_country": "72f5c2e6-74f9-e811-a97a-000d3a2760f2",
  "degree_subject": "Mathematics",
  "uk_degree_grade_id": 222750001,
  "degree_status_id": 222750006,
  "graduation_year": 2028,
  "degree_type_id": 222750000,
  "has_gcse_maths_and_english_id": 222750000,
  "planning_to_retake_gcse_maths_and_english_id": 222750001,
  "has_gcse_science_id": 222750000,
  "planning_to_retake_gcse_science_id": 222750001,
  "preferred_teaching_subject_id": "b02655a1-2afa-e811-a981-000d3a276620",
  "preferred_education_phase_id": 222750000,
  "initial_teacher_training_year_id": 222750001,
  "accepted_policy_id": "4872c8ed-0229-f111-8342-7c1e5285e3ab",
  "type_id": 222750000,
  "channel_id": 222750049,
  "candidate_id": "d85a2f0b-290f-4931-98e2-e7d817ac38f3",
  "adviser_status_id": 222750000,
  "qualification_id": "13da3277-c8ba-4b64-a79e-b0a3960c26be",
  "creation_channel_source_id": 222750000,
  "creation_channel_service_id": 222750010,
  "creation_channel_activity_id": 222750017,
  "subject_taught_id": "b02655a1-2afa-e811-a981-000d3a276620",
  "past_teaching_position_id": "13da3277-c8ba-4b64-a79e-b0a3960c26be",
  "stage_taught_id": 222750000,
  "phone_call_scheduled_at": "2026-12-01T10:00:00Z",
  "situation": 222750000,
  "citizenship": 222750000,
  "visa_status": 222750000,
  "location": 222750000,
  "can_subscribe_to_teacher_training_adviser": false,
  "assignment_status_id": 1234567
}



