class Review < ActiveRecord::Base
  belongs_to :booking
  belongs_to :user
  belongs_to :author, class_name: 'User'

  validates :booking, presence: true
  validates :user, presence: true
  validates :author, presence: true
  validates :rating, presence: true
  validates :comment, presence: true, if: 'rating_is_bad?'

  before_validation :set_user_id, if: 'booking.present?'
  after_save :update_users_rating
  after_destroy :update_users_rating

  scope :visible, -> { where visible: true }

  def set_user_id
    case author
    when booking.user
      self.user_id = booking.beautician_id
    when booking.beautician
      self.user_id = booking.user_id
    else
      errors.add :base, 'Undefined user'
      return false
    end
  end

  def update_users_rating
    user.update_rating!
  end

  def rating_is_bad?
    rating.present? && rating <= 2
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
