# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'solidus_paypal_express/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_paypal_express'
  s.version     = SolidusPayPalExpress::VERSION
  s.summary     = 'Adds PayPal Express as a Payment Method to Solidus Commerce'
  s.description = s.summary
  s.required_ruby_version = '>= 1.9.3'

  s.author       = 'Solidus Commerce'
  s.email        = 'gems@solidus.io'
  s.homepage     = 'http://solidus.io'
  s.license      = %q{BSD-3}

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'solidus_core', ['>= 1.4', '< 3']
  s.add_dependency 'solidus_support'
  s.add_dependency 'paypal-sdk-merchant', '1.117.2'

  # Modern dev/test deps (rspec-rails, factory_bot_rails, database_cleaner,
  # capybara, sprockets, Ruby-3.4 stdlib gems) are supplied by the Gemfile so
  # they can be version-pinned per Rails axis without rewriting the gemspec.
end
