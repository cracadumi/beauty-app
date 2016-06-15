class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.references :user, index: true
      t.references :sub_category, index: true
      t.integer :price

      t.timestamps null: false
    end
  end
end
