class UserRenameLocationLastUpdatedAtToTrackedAt < ActiveRecord::Migration
  def change
    rename_column :users, :location_last_updated_at, :last_tracked_at
  end
end
