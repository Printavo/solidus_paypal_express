class CreateSpreePaypalExpressCheckouts < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_paypal_express_checkouts do |t|
      t.string :token
      t.string :payer_id
    end
  end
end
