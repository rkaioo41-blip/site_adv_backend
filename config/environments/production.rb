require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance.
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Cache assets for far-future expiry.
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # Store uploaded files locally
  config.active_storage.service = :local

  # Logging
  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Health check
  config.silence_healthcheck_path = "/up"

  # No deprecations
  config.active_support.report_deprecations = false

  # ✅ CACHE (simples e seguro)
  config.cache_store = :memory_store

  # ✅ JOBS (sem banco extra)
  config.active_job.queue_adapter = :async

  # ✅ ACTION CABLE (sem banco extra)
  config.action_cable.adapter = :async

  # Mailer
  config.action_mailer.default_url_options = { host: "example.com" }

  # I18n
  config.i18n.fallbacks = true

  # Active Record
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [:id]
end