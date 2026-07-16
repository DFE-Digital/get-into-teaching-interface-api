module CRM
  module Resources
    module Operations
      class HealthCheckResource < BaseStruct
        attribute :git_commit_sha, Types::String.optional
        attribute :environment,    Types::String.optional
        attribute :database,       Types::String.optional
        attribute :hangfire,       Types::String.optional
        attribute :crm,            Types::String.optional
        attribute :redis,          Types::String.optional
        attribute :notify,         Types::String.optional
        attribute :status,         Types::String.optional
      end
    end
  end
end
