class AddUserFields < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :surname, :string
    add_column :users, :username, :string
    add_column :users, :role, :integer, null: false, default: 0
    add_column :users, :sex, :integer, null: false, default: 3
    add_column :users, :bio, :text
    add_column :users, :phone_number, :string
    add_column :users, :dob_on, :date
    add_column :users, :profile_picture_url, :string
    add_column :users, :active, :boolean, null: false, default: false
    add_column :users, :archived, :boolean, null: false, default: false
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :available, :boolean, null: false, default: false
    add_column :users, :rating, :integer, null: false, default: 0
  end
end
