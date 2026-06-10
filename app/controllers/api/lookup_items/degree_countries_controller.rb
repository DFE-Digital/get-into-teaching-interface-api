class API::LookupItems::DegreeCountriesController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      crm_client.lookup_items.degree_countries.all
    end
    render json: data
  end

  private

  def crm_client
    CRM::Client.new
  end
end
