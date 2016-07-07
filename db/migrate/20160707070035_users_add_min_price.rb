class UsersAddMinPrice < ActiveRecord::Migration
  def change
    add_column :users, :min_price, :decimal, precision: 8, scale: 2
  end
end
