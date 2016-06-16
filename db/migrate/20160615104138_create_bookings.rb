class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :status, null: false, default: 0
      t.references :user, index: true
      t.integer :beautician_id, index: true
      t.datetime	:datetime_at
      t.integer :pay_to_beautician, null: false, default: 0
      t.integer :total_price, null: false, default: 0
      t.text :notes
      t.text :unavailability_explanation
      t.boolean :checked_in, null: false, default: false
      t.datetime :expires_at
      t.boolean :instant, null: false, default: false
      t.datetime :reschedule_at

      t.timestamps null: false
    end
  end
end
