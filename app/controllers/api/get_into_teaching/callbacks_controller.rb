class API::GetIntoTeaching::CallbacksController < API::ApplicationController
  def create
    callback = GetIntoTeaching::Callback.new(
      client:,
      request_params:
    )
    # update error responses in swagger
    # is there a way to show which params are optional and which ones are required?
    # Add all params of each post request to swagger

    if callback.create
      render status: 200, json: { response: "OK" }
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
    @client ||= CRM::Client.new
  end
end
