class API::OperationsController < API::ApplicationController
  def health_check
    render json: client.operations.health_check
  end

  def generate_mapping_info
    render json: client.operations.generate_mapping_info
  end

  def pause_crm_integration
    client.operations.pause_crm_integration
    render status: 204
  end

  def resume_crm_integration
    client.operations.resume_crm_integration
    render status: 204
  end

  def backfill_apply_candidates
    client.operations.backfill_apply_candidates(updated_since: params.expect(:updated_since))
    render status: 204
  end

  def backfill_apply_candidates_from_ids
    client.operations.backfill_apply_candidates_from_ids(
      body: { candidate_ids: params.expect(candidate_ids: []) },
    )
    render status: 204
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
