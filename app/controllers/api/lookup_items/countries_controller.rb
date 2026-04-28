class API::LookupItems::CountriesController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      CRM::Client.new.lookup_items.countries.all
    end
    render json: { data: data }
  end
end
