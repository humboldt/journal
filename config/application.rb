require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Journal
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    ActsAsTaggableOn.remove_unused_tags = true
    config.sass.preferred_syntax = :sass
    config.sass.line_comments = false
    config.sass.cache = false
  end
end
