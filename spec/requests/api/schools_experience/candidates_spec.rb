require "rails_helper"
require "swagger_helper"

RSpec.describe "API::SchoolsExperience::Candidates", type: :request do
  before { Rails.cache.clear }
  include APIHelper

  let(:valid_attributes) do
    {
      email: "test@example.com",
      first_name: "John",
      last_name: "Doe",
      preferred_teaching_subject_id: "subject-1",
      address_line_1: "123 Main St",
      address_city: "London",
      address_state_or_province: "London",
      address_postcode: "SW1A 1AA",
      telephone: "01234567890",
      has_dbs_certificate: true,
      accepted_policy_id: "policy-1",
    }
  end

  path "/api/schools_experience/candidates" do
    post("create candidate") do
      let(:Authorization) { "Bearer #{api_token}" }

      tags "Schools Experience"
      consumes "application/json"
      produces "application/json"

      parameter name: :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email: { type: :string, format: :email },
          first_name: { type: :string },
          last_name: { type: :string },
          preferred_teaching_subject_id: { type: :string },
          secondary_preferred_teaching_subject_id: { type: :string },
          address_line_1: { type: :string },
          address_line_2: { type: :string },
          address_line_3: { type: :string },
          address_city: { type: :string },
          address_state_or_province: { type: :string },
          address_postcode: { type: :string },
          telephone: { type: :string },
          has_dbs_certificate: { type: :boolean },
          dbs_certificate_issued_at: { type: :string },
          qualification_id: { type: :string },
          degree_status_id: { type: :string },
          degree_type_id: { type: :string },
          degree_subject: { type: :string },
          uk_degree_grade_id: { type: :string },
          candidate_id: { type: :string },
          creation_channel_source_id: { type: :string },
          creation_channel_service_id: { type: :string },
          creation_channel_activity_id: { type: :string },
          accepted_policy_id: { type: :string },
        },
        required: %w[email first_name last_name preferred_teaching_subject_id address_line_1 address_city address_state_or_province address_postcode telephone has_dbs_certificate accepted_policy_id],
      }

      response(201, "successful") do
        let(:body) { valid_attributes }

        before do
          schools_experience_resource = instance_double(CRM::Adapters::Demo::Resources::SchoolsExperienceResource)
          crm_client = instance_double(CRM::Client, schools_experience: schools_experience_resource)

          allow(schools_experience_resource).to receive(:create_candidate)
                                                  .and_return(Data.define(:body).new(body: { "candidateId" => "abc-123" }))
          allow(CRM::Client).to receive(:new).and_return(crm_client)
        end

        schema type: :object

        example "application/json", "create-candidate", {
          "candidateId" => "abc-123",
        }

        run_test!
      end

      response(400, "validation error") do
        let(:body) { { email: "invalid" } }

        schema type: :object,
               properties: {
                 errors: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       error: { type: :string },
                       message: { type: :string },
                     },
                   },
                 },
               }

        example "application/json", "validation-error", {
          errors: [
            { error: "BadRequest", message: "first_name can't be blank" },
          ],
        }

        run_test!
      end

      response(503, "service unavailable") do
        before do
          schools_experience_resource = instance_double(CRM::Adapters::GetIntoTeaching::Resources::SchoolsExperienceResource)
          crm_client = instance_double(CRM::Client, schools_experience: schools_experience_resource)

          allow(schools_experience_resource).to receive(:create_candidate)
                                                  .and_raise(CRM::Adapters::GetIntoTeaching::Resource::Error)
          allow(CRM::Client).to receive(:new).and_return(crm_client)
        end

        let(:body) { valid_attributes }

        schema type: :object,
               properties: {
                 errors: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       error: { type: :string },
                       message: { type: :string },
                     },
                   },
                 },
               }

        example "application/json", "service-unavailable", {
          errors: [
            { error: "ServiceUnavailable", message: "The upstream service is currently unavailable. Please try again later." },
          ],
        }

        run_test!
      end
    end
  end
end
