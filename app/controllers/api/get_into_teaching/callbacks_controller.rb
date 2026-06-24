class API::GetIntoTeaching::CallbacksController < API::ApplicationController
  def create
    callback = GetIntoTeaching::Callback.new(
      client:,
      request_params:
    )

    if callback.create
      render status: :no_content
    else
      messages = callback.errors.map do |error|
        "#{error.attribute} #{error.message}"
      end
      render_errors(messages, :bad_request)
    end
  end

private

  def request_params
    params.permit(GetIntoTeaching::Callback::ATTRIBUTES.map { |attr| attr[:name] })
  end

  def client
    @client ||= CRM::Client.new(
      adapter: CRM::Adapters::GetIntoTeaching::Client.new,
    )
  end
end
