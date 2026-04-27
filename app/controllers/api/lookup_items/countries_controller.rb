class API::LookupItems::CountriesController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      CRM::Client::Countries.new.all
    end
    render json: { data: data }
  end
end
