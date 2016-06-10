class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true, index: true
      t.string :street
      t.integer :postcode
      t.string :city
      t.string :state
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
