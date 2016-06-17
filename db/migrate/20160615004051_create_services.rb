class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.references :user, index: true
      t.references :sub_category, index: true
      t.decimal :price, precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
