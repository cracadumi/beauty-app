class Booking < ActiveRecord::Base
  enum status: { pending: 0, accepted: 1, expired: 2, refused: 3, completed: 4,
                 canceled: 5, rescheduled: 6 }

  belongs_to :user
  belongs_to :beautician, class_name: 'User'
  has_one :address, as: :addressable, class_name: 'Address',
          inverse_of: :addressable, dependent: :destroy
  has_and_belongs_to_many :services

  accepts_nested_attributes_for :address

  def items
    services.map(&:name).join ', '
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
#  pay_to_beautician          :integer          default(0), not null
#  total_price                :integer          default(0), not null
#  notes                      :text
#  unavailability_explanation :text
#  checked_in                 :boolean          default(FALSE), not null
#  expires_at                 :datetime
#  instant                    :boolean          default(FALSE), not null
#  reschedule_at              :datetime
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_bookings_on_beautician_id  (beautician_id)
#  index_bookings_on_user_id        (user_id)
#
