# factory_bot 4.x's static-attribute syntax routes through ActiveSupport::Deprecation
# at class-load time, which raises on Rails 7.1+; use the block syntax it migrated to.
FactoryBot.define do
  factory :spree_gateway_pay_pal_express,
          class: "Spree::Gateway::PayPalExpress" do
    preferred_login { "solidus-buyer_api1.example.com" }
    preferred_password { "57YMDWBYCDGS53QB" }
    preferred_signature { "AFcWxV21C7fd0v3bYYYRCpSSRl31AFPx.K2zvoXaQZLBnjHSCn0U9epw" }
    preferred_use_new_layout { true }
    name { "PayPal" }
    active { true }
    # `environment` removed: Spree dropped the spree_payment_methods.environment
    # column (1.x-era), so setting it raises UnknownAttributeError; the model
    # never references it.
  end
end
