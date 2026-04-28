class API::LookupItems::DegreeCountriesController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      CRM::Client.new.lookup_items.degree_countries.all
    end
    render json: { data: data }
  end
end
