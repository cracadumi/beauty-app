class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.references :user, index: true
      t.integer :payment_type, null: false, default: 0
      t.integer :last_4_digits
      t.integer :card_type
      t.boolean :default, null: false, default: false

      t.timestamps null: false
    end
  end
end
