class Review < ActiveRecord::Base
  belongs_to :booking
  belongs_to :user
  belongs_to :author, class_name: 'User'

  validates :booking, presence: true
  validates :user, presence: true
  validates :author, presence: true

  after_save :update_users_rating

  scope :visible, -> { where visible: true }

  def update_users_rating
    user.update_rating!
  end
end

# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  booking_id :integer
#  user_id    :integer
#  rating     :integer          default(1), not null
#  comment    :text
#  author_id  :integer
#  visible    :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reviews_on_author_id   (author_id)
#  index_reviews_on_booking_id  (booking_id)
#  index_reviews_on_user_id     (user_id)
#
