class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name
      t.string :country
      t.string :flag_url

      t.timestamps null: false
    end
  end
end
