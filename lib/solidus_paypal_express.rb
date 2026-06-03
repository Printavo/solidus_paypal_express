require 'solidus_core'
# engine.rb does `include SolidusSupport::EngineExtensions` but never required the
# gem; the constant only resolved by accident via another loaded engine's autoload
# (latent since solidusio-contrib/solidus_paypal_express@ee47919).
require 'solidus_support'
require 'solidus_paypal_express/version'
require 'solidus_paypal_express/engine'
require 'paypal-sdk-merchant'
