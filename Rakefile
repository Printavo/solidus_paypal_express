require 'bundler'

Bundler::GemHelper.install_tasks

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
  # LIB_NAME drives `require ENV['LIB_NAME']` in common_rake; the entry file was
  # renamed spree_paypal_express.rb -> solidus_paypal_express.rb, so the stale
  # value raised LoadError before the dummy app could be generated.
  ENV['LIB_NAME'] = 'solidus_paypal_express'
  Rake::Task['extension:test_app'].invoke

  Rake::Task['test_app:seed_manifest'].invoke
  Rake::Task['test_app:load_schema'].invoke
end

namespace :test_app do
  # Rails 8 generates a dummy app without app/assets/config/manifest.js, and
  # sprockets-rails 3.5 aborts boot with Sprockets::Railtie::ManifestNeededError
  # before the schema is loaded. Seed a minimal manifest so the app boots.
  # (mirrors solidusio/solidus#3379, solidusio/solidus#6327)
  task :seed_manifest do
    manifest = File.join('spec', 'dummy', 'app', 'assets', 'config', 'manifest.js')
    unless File.exist?(manifest)
      FileUtils.mkdir_p(File.dirname(manifest))
      File.write(manifest, "//= link_tree ../images\n//= link_directory ../stylesheets .css\n")
    end
  end

  # rake test_app's chained db:create/db:migrate can leave the sqlite file with
  # no schema; load it explicitly so the suite has tables. ActiveRecord::Migration
  # .maintain_test_schema! in the spec helper is the standard recovery on top.
  task :load_schema do
    Dir.chdir('spec/dummy') do
      sh 'bin/rails db:environment:set RAILS_ENV=test'
      sh 'bin/rails db:schema:load RAILS_ENV=test'
    end
  end
end
