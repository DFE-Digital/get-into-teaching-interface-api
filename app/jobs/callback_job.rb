class CallbackJob < ApplicationJob
  self.queue_adapter = :solid_queue

  def perform
    client = CRM::Client.new(adapter: CRM::Adapters::GetIntoTeaching::Client.new)
    client.get_into_teaching.callbacks.create(body)
  end

  private

  def body
    {
      "degreeStatusId": 222750000,
      "countryId": "38ce2d0f-0b1f-ee11-9967-6045bd8c5762",
      "acceptedPolicyId": "4872c8ed-0229-f111-8342-7c1e5285e3ab",
      "typeId": 222750000,
      "ukDegreeGradeId": 222750001,
      "degreeTypeId": 222750000,
      "initialTeacherTrainingYearId": 222750001,
      "preferredEducationPhaseId": 222750000,
      "preferredTeachingSubjectId": "b02655a1-2afa-e811-a981-000d3a276620",
      "hasGcseMathsAndEnglishId": 222750000,
      "hasGcseScienceId": 222750000,
      "planningToRetakeGcseMathsAndEnglishId": 222750001,
      "planningToRetakeGcseScienceId": 222750001,
      "channelId": 222750049,
      "creationChannelSourceId": 222750000,
      "creationChannelServiceId": 222750010,
      "creationChannelActivityId": 222750017,
      "email": "isreal.nikolaus6158@example.com",
      "firstName": "Isreal",
      "lastName": "Nikolaus",
      "dateOfBirth": "2001-06-01",
      "degreeSubject": "Mathematics",
      "addressTelephone": "07735 861129",
      "addressPostcode": "SA9J 4FJ",
    }
  end
end
