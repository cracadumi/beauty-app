class Booking < ActiveRecord::Base
  include Statusable

  belongs_to :user
  belongs_to :beautician, class_name: 'User'
  belongs_to :payment_method
  has_one :address, as: :addressable, class_name: 'Address',
          inverse_of: :addressable, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :refunds, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_and_belongs_to_many :services

  accepts_nested_attributes_for :address

  validates :user, presence: true
  validates :beautician, presence: true
  validates :services, presence: true

  before_create :check_already_booked
  after_create :set_expires_at
  after_save :updates_service_info

  def check_already_booked
    return unless user.bookings.where(beautician_id: beautician_id,
                                      status: Booking.statuses[:pending]).any?
    errors.add :base, 'You have a pending booking already with beautician'
    false
  end

  def set_expires_at
    expires_at = instant? ? 3.minutes.from_now : 1.day.from_now
    update_column :expires_at, expires_at
  end

  def updates_service_info
    items = services.map(&:name).join(', ')
    pay_to_beautician = services.sum(:price)
    total_price = pay_to_beautician * (100 + Settings.platform_fee.to_i) / 100
    update_columns pay_to_beautician: pay_to_beautician,
                   total_price: total_price,
                   items: items
  end

  def display_name
    "#{id}. #{beautician.display_name} -> #{user.display_name}: #{items}"
  end

  def future_event?
    instant? || datetime_at > Time.zone.now
  end

  def may_check_in?
    accepted? && datetime_at + 1.hour > Time.zone.now
  end

  def check_in!
    update_attribute :checked_in, true
    complete!
  end
end

# == Schema Information
#
# Table name: bookings
#
#  id                         :integer          not null, primary key
#  status                     :integer          default(0), not null
#  user_id                    :integer
#  beautician_id              :integer
#  datetime_at                :datetime
#  pay_to_beautician          :decimal(8, 2)
#  total_price                :decimal(8, 2)
#  notes                      :text
#  unavailability_explanation :text
#  checked_in                 :boolean          default(FALSE), not null
#  expires_at                 :datetime
#  instant                    :boolean          default(FALSE), not null
#  reschedule_at              :datetime
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  items                      :string
#  payment_method_id          :integer
#
# Indexes
#
#  index_bookings_on_beautician_id  (beautician_id)
#  index_bookings_on_user_id        (user_id)
#
