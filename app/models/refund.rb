class Refund < ActiveRecord::Base
  belongs_to :booking

  validates :booking, presence: true
end

# == Schema Information
#
# Table name: refunds
#
#  id                           :integer          not null, primary key
#  booking_id                   :integer
#  refunded_at                  :datetime
#  amount_refunded_to_performer :decimal(8, 2)
#  amount_refunded_to_customer  :decimal(8, 2)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_refunds_on_booking_id  (booking_id)
#
