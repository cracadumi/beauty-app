class CreateSubCategories < ActiveRecord::Migration
  def change
    create_table :sub_categories do |t|
      t.references :category, index: true
      t.string :name

      t.timestamps null: false
    end
  end
end
