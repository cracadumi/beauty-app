class UsersProfilePictureUrl < ActiveRecord::Migration
  def change
    rename_column :users, :profile_picture, :profile_picture_url
  end
end
