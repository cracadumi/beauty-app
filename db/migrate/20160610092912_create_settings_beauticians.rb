class CreateSettingsBeauticians < ActiveRecord::Migration
  def change
    create_table :settings_beauticians do |t|
      t.references :user, index: true
      t.boolean :instant_booking, null: false, default: false
      t.boolean :advance_booking, null: false, default: false
      t.boolean :mobile, null: false, default: false
      t.boolean :office, null: false, default: false
      t.string :profession

      t.timestamps null: false
    end
  end
end
