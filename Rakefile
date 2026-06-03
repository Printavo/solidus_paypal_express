require 'bundler'
require 'fileutils'

Bundler::GemHelper.install_tasks

# Rails 8 generates the dummy app without app/assets/config/manifest.js, and
# sprockets-rails 3.5 aborts every app boot with
# Sprockets::Railtie::ManifestNeededError. Seed a minimal manifest. Defined as a
# method (not a once-only rake task) because it must run more than once: the
# solidus install generator rewrites app/assets and drops the file again.
# (mirrors solidusio/solidus#3379 and #6122, which fixes issue #6327)
def seed_manifest!
  dir = File.join('spec', 'dummy', 'app', 'assets', 'config')
  sh "mkdir -p #{dir}"
  sh "printf '//= link_tree ../images\\n//= link_directory ../stylesheets .css\\n' > #{File.join(dir, 'manifest.js')}"
end

begin
  require 'spree/testing_support/extension_rake'
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task default: %i(first_run spec)
rescue LoadError
  # no rspec available
end

task :first_run do
  if Dir['spec/dummy'].empty?
    Rake::Task[:test_app].invoke
    Dir.chdir('../../')
  end
end

desc 'Generates a dummy app for testing'
task :test_app do
  # LIB_NAME drives `require ENV['LIB_NAME']` below; the entry file was renamed
  # spree_paypal_express.rb -> solidus_paypal_express.rb, so the stale value
  # raised LoadError before the dummy app could be generated.
  ENV['LIB_NAME'] = 'solidus_paypal_express'

  # Reimplements common:test_app (spree/testing_support/common_rake) so the
  # sprockets manifest can be seeded around each step that boots the dummy app;
  # the stock task boots before the manifest exists and aborts on Rails 8.
  require 'spree/testing_support/common_rake'
  unless defined?(Solidus::InstallGenerator)
    require 'generators/solidus/install/install_generator'
  end
  require 'generators/spree/dummy/dummy_generator'
  require ENV['LIB_NAME']

  Spree::DummyGeneratorHelper.inject_extension_requirements = true
  ENV['RAILS_ENV'] = 'test'
  lib_name = ENV['LIB_NAME']

  Spree::DummyGenerator.start ["--lib_name=#{lib_name}", "--quiet"]

  # Seed the manifest before the install generator: on Rails 8 it boots the
  # dummy app, and without the manifest sprockets-rails 3.5 aborts that boot.
  seed_manifest!

  Solidus::InstallGenerator.start [
    "--lib_name=#{lib_name}", "--auto-accept", "--with-authentication=false",
    "--payment-method=none", "--migrate=false", "--seed=false", "--sample=false",
    "--quiet", "--user_class=Spree::LegacyUser"
  ]

  # Re-seed: the install generator rewrites app/assets and drops the manifest.
  seed_manifest!

  Dir.chdir('spec/dummy') do
    sh 'bundle exec rails db:environment:set RAILS_ENV=test'
    sh 'bundle exec rails db:drop db:create RAILS_ENV=test'
    sh 'bundle exec rails railties:install:migrations RAILS_ENV=test'
    # Separate invocation so a populated schema is guaranteed; the chained
    # db:create/db:migrate occasionally left the sqlite file empty. Migrate
    # (not schema:load) so the engine's namespaced migration versions land in
    # schema_migrations.
    sh 'bundle exec rails db:migrate RAILS_ENV=test'
  end
end
