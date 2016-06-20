class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :booking, index: true
      t.references :user, index: true
      t.integer :rating, null: false, default: true
      t.text :comment
      t.integer :author_id, index: true
      t.boolean :visible, null: false, default: true

      t.timestamps null: false
    end
  end
end
