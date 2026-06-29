module HostingEnvironment
  def self.environment_name
    ENV.fetch("HOSTING_ENVIRONMENT_NAME", "unknown-environment")
  end

  def self.development?
    environment_name == "development"
  end

  def self.production?
    environment_name == "production"
  end

  def self.review?
    environment_name.start_with?("pr-")
  end
end
