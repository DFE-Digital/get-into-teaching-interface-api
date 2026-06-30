class API::MailingList::MembersController < API::ApplicationController
  def create
    member = MailingList::Member.new(
      client:,
      request_params:
    )

    if response = member.create
      render status: 200, json: response
    else
      messages = member.errors.map do |error|
        "#{error.attribute} #{error.message}"
      end
      render_errors(messages, :bad_request)
    end
  end

  private

  def request_params
    params.permit(
      MailingList::Member::ATTRIBUTES.map { |attr| attr[:name] }
    )
  end

private

  def client
    @client ||= CRM::Client.new(
      adapter: CRM::Adapters::GetIntoTeaching::Client.new(
        api_key: @current_api_token.crm_key,
      )
    )
  end
end
