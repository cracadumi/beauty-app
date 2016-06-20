class BookingAddPaymentMethod < ActiveRecord::Migration
  def change
    add_column :bookings, :payment_method_id, :integer
  end
end
