# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  config.gem 'json'
  config.gem 'binarylogic-authlogic', :lib => 'authlogic', :source => 'http://gems.github.com'
  config.gem 'ym4r'

  config.time_zone = 'UTC'

  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
  # config.i18n.default_locale = :de
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
end