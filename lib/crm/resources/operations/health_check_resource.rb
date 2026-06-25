module CRM
  module Resources
    module Operations
      HealthCheckResource = Data.define(
        :git_commit_sha,
        :environment,
        :database,
        :hangfire,
        :crm,
        :redis,
        :notify,
        :status,
      )
    end
  end
end
