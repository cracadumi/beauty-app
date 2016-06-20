class CreateRefunds < ActiveRecord::Migration
  def change
    create_table :refunds do |t|
      t.references :booking, index: true
      t.datetime :refunded_at
      t.decimal :amount_refunded_to_performer, precision: 8, scale: 2
      t.decimal :amount_refunded_to_customer, precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
