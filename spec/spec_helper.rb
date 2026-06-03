if ENV["COVERAGE"]
  exlist = Dir.glob([
    'db/**/*.rb',
    'spec/**/*.rb'
  ])

  require 'simplecov'
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start do
    exlist.each do |p|
      add_filter p
    end
  end
end

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rspec/rails'
require 'rspec/active_model/mocks'
require 'database_cleaner'
require 'ffaker'
require 'capybara/rspec'
require 'capybara/rails'

# poltergeist/PhantomJS is dead; guard the require so the JS feature spec is
# simply skipped (env-blocked) rather than crashing the whole suite at load.
begin
  require 'capybara/poltergeist'
  Capybara.register_driver :poltergeist do |app|
    # Required to visit https://www.sandbox.paypal.com
    Capybara::Poltergeist::Driver.new(app, phantomjs_options: %w[--ssl-protocol=any --ignore-ssl-errors=true])
  end
  Capybara.javascript_driver = :poltergeist
rescue LoadError
  # poltergeist unavailable: JS/feature specs cannot run in this environment.
end

Capybara.default_max_wait_time = ENV['DEFAULT_MAX_WAIT_TIME'].to_f if ENV['DEFAULT_MAX_WAIT_TIME'].present?

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

# `spree/testing_support/factories` now just emits a deprecation and bails; use the
# non-deprecated loader it points to (mirrors solidusio/solidus factory_bot migration).
require 'spree/testing_support/factory_bot'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/url_helpers'

require 'solidus_paypal_express/factories'
# add_paths_and_load! only registers Spree core + lib factories; the deprecated
# FactoryGirl.find_definitions used to auto-scan spec/factories, so register that
# directory here to keep this extension's own factory available.
FactoryBot.definition_file_paths << File.expand_path('factories', __dir__)
Spree::TestingSupport::FactoryBot.add_paths_and_load!

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Spree::TestingSupport::UrlHelpers
  config.include Spree::TestingSupport::AuthorizationHelpers::Controller

  config.mock_with :rspec
  config.color = true
  config.use_transactional_fixtures = false

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before do |example|
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.fail_fast = ENV['FAIL_FAST'] || false

  config.infer_spec_type_from_file_location!
end
