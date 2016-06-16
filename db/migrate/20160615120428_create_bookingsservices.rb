class CreateBookingsservices < ActiveRecord::Migration
  def change
    create_table :bookings_services do |t|
      t.references :booking, index: true
      t.references :service, index: true
    end
  end
end
