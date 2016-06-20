class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :booking, index: true
      t.references :user, index: true
      t.references :payment_method, index: true
      t.datetime :paid_at
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
