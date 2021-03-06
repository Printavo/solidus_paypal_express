module Spree
  class PaypalExpressCheckout < ActiveRecord::Base
    def actions
      ["capture"]
    end

    def can_capture? payment
      payment.pending?
    end

    def can_credit? payment
      payment.completed?
    end
  end
end
