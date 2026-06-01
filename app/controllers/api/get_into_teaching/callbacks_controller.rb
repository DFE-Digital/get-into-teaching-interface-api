class API::GetIntoTeaching::CallbacksController < API::ApplicationController
  def create
    render status: 200, json: { OK: true }
  end
end
