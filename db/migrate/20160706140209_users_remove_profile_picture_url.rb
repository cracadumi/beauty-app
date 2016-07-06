class UsersRemoveProfilePictureUrl < ActiveRecord::Migration
  def change
    remove_column :users, :profile_picture_url, :string
  end
end
