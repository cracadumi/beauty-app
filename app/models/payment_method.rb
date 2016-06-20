class PaymentMethod < ActiveRecord::Base
  belongs_to :user
  has_many :bookings
  has_many :payments

  enum payment_type: { card: 0 }
  enum card_type: { visa: 0, mastercard: 1 }

  validates :user, presence: true
  validates :payment_type, presence: true
end

# == Schema Information
#
# Table name: payment_methods
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  payment_type  :integer          default(0), not null
#  last_4_digits :integer
#  card_type     :integer
#  default       :boolean          default(FALSE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_payment_methods_on_user_id  (user_id)
#
