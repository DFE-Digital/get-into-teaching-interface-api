# frozen_string_literal: true

module ErrorHandling
  extend ActiveSupport::Concern

  included do
    # Error must be declared first. Rails searches rescue_handlers in reverse declaration order
    # (last-declared wins). Since NotFoundError < Error, both handlers match a NotFoundError;
    # declaring Error first ensures the NotFoundError handler (declared last) takes priority.
    rescue_from CRM::Adapters::GetIntoTeaching::Resource::Error do
      render json: { error: { message: I18n.t("api.errors.service_unavailable") } }, status: :service_unavailable
    end

    rescue_from CRM::Adapters::GetIntoTeaching::Resource::NotFoundError do
      resource_name = not_found_resource_name
      render json: {
        error: {
          message: I18n.t("api.errors.not_found", resource: resource_name.singularize.humanize.downcase, id: not_found_id),
          resource: resource_name,
          id: not_found_id,
        },
      }, status: :not_found
    end

    rescue_from CRM::Adapters::GetIntoTeaching::Resource::BadRequestError do |exception|
      render json: { error: { message: exception.message } }, status: :bad_request
    end

    rescue_from CRM::Adapters::GetIntoTeaching::Resource::UnauthorizedError do |exception|
      render json: { error: { message: exception.message } }, status: :unauthorized
    end

    private

    def not_found_resource_name
      controller_name
    end

    def not_found_id
      params[:id]
    end
  end
end
