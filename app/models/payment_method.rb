class PaymentMethod < ActiveRecord::Base
  belongs_to :user
  has_many :bookings
  has_many :payments

  enum payment_type: { card: 0 }
  enum card_type: { visa: 0, mastercard: 1 }

  validates :user, presence: true
  validates :payment_type, presence: true
  validates :last_4_digits, uniqueness: { scope: :user_id },
                            if: 'last_4_digits.present?'

  before_save :set_default_if_first
  after_save :remove_old_default
  before_destroy :dont_remove_default

  def set_default_if_first
    return if user.payment_methods.any?
    set_default
  end

  def remove_old_default
    user.payment_methods.where(default: true).where.not(id: id)
        .update_all default: false
  end

  def dont_remove_default
    return true unless default?
    errors.add :base, 'You can\'t delete your default payment method'
    false
  end

  def set_default
    self.default = true
  end

  def set_default!
    self.default = true
    save
  end
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
