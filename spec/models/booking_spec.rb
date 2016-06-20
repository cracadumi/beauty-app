require 'rails_helper'

describe Booking, type: :model do
  let(:user) { create :user }
  let(:beautician) { create :user }
  let(:service) { create :service, price: 150.50 }
  subject do
    build :booking, user: user, beautician: beautician, services: [service]
  end

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'not valid without user' do
    subject.user = nil

    expect(subject).not_to be_valid
  end

  it 'not valid without beautician' do
    subject.beautician = nil

    expect(subject).not_to be_valid
  end

  it 'not valid without services' do
    subject.services = []

    expect(subject).not_to be_valid
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
