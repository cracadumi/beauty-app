class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.references :settings_beautician, index: true
      t.integer :day
      t.time :starts_at, null: false, default: '09:00'
      t.time :ends_at, null: false, default: '17:00'
      t.boolean :working_day, null: false, default: true


      t.timestamps null: false
    end
  end
end
