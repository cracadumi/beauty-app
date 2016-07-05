class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :beautician, class_name: 'User'

  validates :user, presence: true
  validates :beautician, presence: true
end

# == Schema Information
#
# Table name: favorites
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  beautician_id :integer
#
# Indexes
#
#  index_favorites_on_beautician_id  (beautician_id)
#  index_favorites_on_user_id        (user_id)
#
