if defined?(Rails::Console)
  Rails.application.config.console_prompt = "get-into-teaching-interface-api(#{ENV.fetch('HOSTING_ENVIRONMENT_NAME', 'unknown')})"
end
