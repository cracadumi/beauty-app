class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :picturable, polymorphic: true, index: true
      t.string :title
      t.text :description
      t.string :picture_url

      t.timestamps null: false
    end
  end
end
