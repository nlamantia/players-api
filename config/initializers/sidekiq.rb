# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq/web'

redis_url = "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}/#{ENV['REDIS_NAMESPACE']}"

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', redis_url) }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', redis_url) }
end
