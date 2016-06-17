class BookingAddItems < ActiveRecord::Migration
  def change
    add_column :bookings, :items, :string
  end
end
