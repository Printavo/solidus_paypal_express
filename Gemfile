source 'https://rubygems.org'

# Solidus 2.11.16 + Rails 8 compat + state_machines <0.10 pin; works on both the
# Rails 7.2 and Rails 8.0 axes (Printavo/solidus rails-8.0-support branch).
gem 'solidus', git: 'https://github.com/Printavo/solidus.git', branch: 'rails-8.0-support'
gem 'solidus_auth_devise'

# Rails version selected per-axis by the harness (RAILS_VERSION env var).
gem 'rails', ENV['RAILS_VERSION'], require: false

gem 'sqlite3'
# mysql2/pg removed from the harness: the dummy app and test suite run on sqlite,
# and the native mysql/pg client libs are not present in CI.

# Ruby 3.4 extracted these from the default gems to bundled/external gems;
# paypal-sdk-merchant 1.117.2 and factory_bot 4.x transitively require them.
gem 'observer'
gem 'mutex_m'
gem 'benchmark'

group :test do
  gem 'rspec-rails', '~> 7.1' # 8.x dropped fixture_path= which rspec-rails relies on
  gem 'factory_bot_rails', '~> 4.11' # 4.x kept to match the FactoryBot-era factories
  gem 'database_cleaner', '~> 2.0'
  gem 'rails-controller-testing' # restores assigns for controller specs
  gem 'sprockets', '~> 4'
  gem 'rspec-activemodel-mocks'
  gem 'ffaker'
  gem 'capybara'
end

gemspec
