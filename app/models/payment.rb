class Payment < ActiveRecord::Base
  belongs_to :booking
  belongs_to :user
  # belongs_to :payment_method

  validates :booking, presence: true
  validates :user, presence: true
end

# == Schema Information
#
# Table name: payments
#
#  id                :integer          not null, primary key
#  booking_id        :integer
#  user_id           :integer
#  payment_method_id :integer
#  paid_at           :datetime
#  amount            :decimal(8, 2)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_payments_on_booking_id         (booking_id)
#  index_payments_on_payment_method_id  (payment_method_id)
#  index_payments_on_user_id            (user_id)
#
