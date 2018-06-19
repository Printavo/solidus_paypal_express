class AddStateToSpreePaypalExpressCheckouts < ActiveRecord::Migration[5.0]
  def change
    add_column :spree_paypal_express_checkouts, :state, :string, default: "complete"
  end
end
