module PayPal
  module SDK
    module Merchant
      module DataTypes
        class RefundTransactionResponseType
          def authorization
            self.RefundTransactionID
          end
        end
      end
    end
  end
end
