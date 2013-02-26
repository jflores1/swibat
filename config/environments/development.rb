Swibat::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  require 'pusher'

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not serve compiled assets in development
  config.serve_static_assets = false

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  #Default URL options
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  #Enable threading
  #config.threadsafe!

  #Eager load paths
  #config.eager_load_paths += ["#{config.root}/lib"]
  
  config.after_initialize do
    WickedPdf.config = {
      :exe_path => "/usr/local/bin/wkhtmltopdf"
      }
  end

  Pusher.app_id = '36952'
  Pusher.key    = 'b90f3c930c20605caf52'
  Pusher.secret = 'd6435a48026f16567999'

end
