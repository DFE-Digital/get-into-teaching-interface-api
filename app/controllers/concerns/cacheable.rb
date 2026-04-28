# frozen_string_literal: true

module Cacheable
  extend ActiveSupport::Concern

  CacheOptions = Data.define(:key, :expires_in, :force)

  included do
    def cache_options
      CacheOptions.new(key: endpoint_cache_key, expires_in: cache_expires_in, force: force_cache_miss?)
    end
  end

  private

  def endpoint_cache_key
    request.path
  end

  def cache_expires_in
    2.hours
  end

  def force_cache_miss?
    force_cache_miss_param = params.fetch(:force_cache_miss, Rails.env.local?)
    puts force_cache_miss_param
    ActiveModel::Type::Boolean.new.cast(force_cache_miss_param)
  end
end
