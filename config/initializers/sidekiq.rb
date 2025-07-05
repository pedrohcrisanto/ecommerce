require 'sidekiq'
require 'sidekiq-cron'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }

  config.on(:startup) do
    schedule_file = Rails.root.join('config', 'sidekiq-cron.yml')
    if File.exist?(schedule_file) && Sidekiq::Cron::Job.respond_to?(:load_from_hash!)
      Sidekiq::Cron::Job.load_from_hash!(YAML.load_file(schedule_file))
      Rails.logger.info("Sidekiq-cron jobs loaded from #{schedule_file}")
    else
      Rails.logger.warn("Sidekiq-cron schedule file not found or Sidekiq::Cron::Job.load_from_hash! is not available.")
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
end
