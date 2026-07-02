Sentry.init do |config|
  config.dsn = ENV["SENTRY_DSN"]
  config.breadcrumbs_logger = [ :active_support_logger, :http_logger ]
  config.environment = HostingEnvironment.environment_name
  config.enabled_environments = %w[production qa]
  config.send_default_pii = true

  filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)

  config.before_send = lambda do |event, hint|
    event.extra = filter.filter(event.extra) if event.extra
    event.user = filter.filter(event.user) if event.user
    event.contexts = filter.filter(event.contexts) if event.contexts

    if data = JsonParser.parse(event.request&.data)
      event.request.data = filter.filter(data)
    end

    event
  end
end
