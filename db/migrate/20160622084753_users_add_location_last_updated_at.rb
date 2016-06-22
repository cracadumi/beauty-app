class UsersAddLocationLastUpdatedAt < ActiveRecord::Migration
  def change
    add_column :users, :location_last_updated_at, :datetime
  end
end
